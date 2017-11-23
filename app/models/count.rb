class Count < ApplicationRecord
  after_create :is_empty, if: ->(obj) {obj.goods == true}

  belongs_to :product

  def is_empty
    if self.goods # 수량 증가가 있을 경우
      p = Product.find(self.product_id)
      if p.counts.where(date: Date.today - 8).present? # 등록된지 7일 이상일 경우
        sum = 0
        for i in 1..7 do
          date = p.counts.last.date
          sum += p.counts.where(date: (date.to_date - i + 1).to_s).take.buffer
          sum += p.counts.where(date: (date.to_date - i).to_s).take.count
          sum -= p.counts.where(date: (date.to_date - i + 1).to_s).take.count
        end
        avg = sum/7 # 일주일 평균 판매량
        if self.count/avg > 30 # 판매 가능일 수 30일 이상일 경우
          p.update(empty: false)
        end
      end
    end
  end
end
