class ProductsController < ApplicationController
  require 'mechanize'
  require 'json'
  require 'date'

  def index
    @products = Product.all.order(:name)

    @count = 0
    @products.each do |p|
      @count += p.counts.last.count
    end

    @price = 0
    @products.each do |p|
      @price += p.counts.last.count * p.price
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @productss }
    end
  end

  def new
    mechanize = Mechanize.new
    login = mechanize.get('https://www.901giji.com/scm/index.php/member/login')

    #look for the wanted form
    form = login.form_with action: "https://www.901giji.com/scm/index.php/member/login_chk"
    form.field_with(name: "id").value = ENV['SCM_ID']
    form.field_with(name: "password").value = ENV['SCM_PASSWORD']
    form.submit

    scm = mechanize.get("https://www.901giji.com/scm/index.php/product/search")

    @data = {}
    count = scm.parser.css("table.table tbody tr").count

    for i in 1..count do
      @data[scm.parser.css("table.table tbody tr[#{i}] td[2]").text.to_sym] = scm.parser.css("table.table tbody tr[#{i}] td[8]").text.tr(',','').to_i
    end

    @products = Product.all.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @homes }
    end
  end

  def create
    Product.all.each do |p|
      Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today)
    end

    respond_to do |format|
      format.html { redirect_to products_path }
      format.xml  { render xml: @product, status: :created, location: @product }
    end
  end

  def raw
    date = Date.today - 7
    @products = Product.all
    @count = Count.where("date > ?", date).all
  end
end
