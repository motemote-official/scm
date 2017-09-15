class CountsController < ApplicationController
  before_action :authenticate_user!

  require 'mechanize'
  require 'json'
  require 'date'

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
      if Count.where(product_id: p.id).where(date: (Date.today - 1).to_s).take.present?
        if params[:"#{p.id}"].to_i > Count.where(product_id: p.id).where(date: (Date.today - 1).to_s).take.count
          Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today, goods: true)
        else
          Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today, goods: false)
        end
      else
        Count.create(count: params[:"#{p.id}"], product_id: p.id, date: Date.today, goods: true)
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
      if @count.update(count: params[:count], buffer: params[:buffer])
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
