class CountsController < ApplicationController
  require 'mechanize'
  require 'json'
  require 'date'

  def new
    mechanize = Mechanize.new
    login = mechanize.get('http://sr01.srwms.com/wms/user/login')

    #look for the wanted form
    form = login.form_with action: "http://sr01.srwms.com/wms/user/login_chk"
    form.field_with(name: "company_code").value = ENV['SCM_COMPANY_CODE']
    form.field_with(name: "id").value = ENV['SCM_ID']
    form.field_with(name: "password").value = ENV['SCM_PASSWORD']
    form.submit

    scm = mechanize.get("http://sr01.srwms.com/wms/inventory/stock/basic_list?page_per_list=100&search_mode=Y&member_ids%5B%5D=3&upc=&product_name=&product_code=&product_codes=")

    @data = {}
    count = scm.parser.css("table.tb-comm tbody tr").count

    for i in 1..count do
      @data[scm.parser.css("table.tb-comm tbody tr[#{i}] td[2]").text.to_sym] = scm.parser.css("table.tb-comm tbody tr[#{i}] td[9]").text.tr(',','').to_i
    end

    @products = Product.all.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @homes }
    end
  end

  def create
    Product.all.each do |p|
      if !Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.nil?
        if params[:"#{p.id}"].to_i > Count.where(product_id: p.id).where(date: (Date.today.in_time_zone("Seoul") - 1).to_s).take.count
          Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: true)
        else
          Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
        end
      else
        Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today.in_time_zone("Seoul"), goods: false)
      end
    end

    respond_to do |format|
      format.html { redirect_to products_path }
      format.xml  { render xml: @product, status: :created, location: @product }
    end
  end

  def edit
    @count = Count.find(params[:id])
  end

  def update
    @count = Count.find(params[:id])

    respond_to do |format|
      if @count.update(count: params[:count], buffer: params[:buffer], description: params[:description])
        flash[:notice] = 'ModelClassName was successfully updated.'
        format.html { redirect_to products_raw_path }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @count.errors, status: :unprocessable_entity }
      end
    end
  end
end
