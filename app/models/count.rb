class Count < ApplicationRecord
  after_create :is_empty, if: ->(obj) {obj.product.empty == true}

  belongs_to :product

  def is_empty
    p = Product.find(self.product_id)

    if !p.counts.where(date: Date.today - 7).take.nil? # 등록된지 7일 이상일 경우
      sum = 0
      is_nil = false

      for i in 1..7 do
        # p.counts = nil 확인
        if p.counts.where(date: (date.to_date - i).to_s).take.nil? || p.counts.where(date: (date.to_date - i + 1).to_s).take.nil?
          is_nil = true
        else
          date = p.counts.last.date
          sum = sum + p.counts.where(date: (date.to_date - i + 1).to_s).take.buffer + p.counts.where(date: (date.to_date - i).to_s).take.count - p.counts.where(date: (date.to_date - i + 1).to_s).take.count
        end
      end

      unless is_nil
        avg = sum/7 # 일주일 평균 판매량
        if avg > 0
          if self.count/avg > 60 # 판매 가능일 수 30일 이상일 경우
            p.update(empty: false)
          end
        end
      end
    end
  end
end
