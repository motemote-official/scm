class Product < ApplicationRecord
  require 'mechanize'
  require 'json'
  require 'date'

  has_many :counts, dependent: :destroy

  mount_uploader :image, ProductUploader

  def self.whenever_create
    mechanize = Mechanize.new
    login = mechanize.get('https://wms.nosnos.kr/wms/user/login')

    #look for the wanted form
    form = login.form_with(action: "https://wms.nosnos.kr/wms/user/login_chk")
    form.field_with(name: "company_code").value = ENV['SCM_COMPANY_CODE']
    form.field_with(name: "id").value = ENV['SCM_ID']
    form.field_with(name: "password").value = ENV['SCM_PASSWORD']
    form.submit

    scm = mechanize.get("https://wms.nosnos.kr/wms/inventory/stock/basic_list?page_per_list=100&search_mode=Y&member_ids%5B%5D=3&category_id=&upc=&product_name=&product_code=&product_codes=&stock_search_type=all&stock_start_cnt=&stock_end_cnt=")

    @data = {}
    count = scm.parser.css("table.tb-comm tbody tr").count

    for i in 1..count do
      @data[scm.parser.css("table.tb-comm tbody tr[#{i}] td[2]").text.to_sym] = scm.parser.css("table.tb-comm tbody tr[#{i}] td[9]").text.tr(',','').to_i
    end

    Product.all.each do |p|
      count = @data[:"#{p.code}"]

      if count.nil?
        Count.create(count: 0, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
      else
        if Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.present?
          if count > Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.count
            Count.create(count: count.nil? ? 0 : count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: true)
          else
            Count.create(count: count.nil? ? 0 : count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
          end
        else
          Count.create(count: count.nil? ? 0 : count, product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
        end
      end
    end
  end
end
