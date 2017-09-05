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

    # 7일간 판매 평균 계산

    @average = []

    for i in 0..2 do
      sum = []
      @products.each do |p|
        for j in (7*i+1)..(7*i+7) do
          date = p.counts.last.date
          if sum[p.id].nil?
            sum[p.id] = 0
          end
          sum[p.id] = sum[p.id] + p.counts.where(date: (date.to_date - j + 1).to_s).take.buffer + p.counts.where(date: (date.to_date - j).to_s).take.count - p.counts.where(date: (date.to_date - j + 1).to_s).take.count
        end
      end

      avg = []
      sum.each_with_index do |s, index|
        if s.nil?
          s = 0
        end
        avg[index] = s/7
      end

      @average[i] = avg
    end

    @sell = []
    @products.each do |p|
      if @average[0][p.id] != 0
        @sell[p.id] = p.counts.last.count/@average[0][p.id]
      else
        @sell[p.id] = "-"
      end
    end

    # 판매 비중
    @ratio = []
    total = 0
    @products.each do |p|
      total += @average[0][p.id] * p.price
    end
    @products.each do |p|
      @ratio[p.id] = (@average[0][p.id] * p.price)/total*100
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

  def edit
    @count = Count.find(params[:id])
  end

  def update
    @count = Count.find(params[:id])

    respond_to do |format|
      if @count.update(buffer: params[:buffer])
        flash[:notice] = 'ModelClassName was successfully updated.'
        format.html { redirect_to products_raw_path }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @count.errors, status: :unprocessable_entity }
      end
    end
  end

  def raw
    @products = Product.all
    @count = Count.all
    @date =  Count.all.pluck(:date).uniq.count

    puts @date
  end
end
