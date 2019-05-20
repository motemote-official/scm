class ProductsController < ApplicationController
  require "mini_magick"

  def index
    @products = Product.all.order(:name)

    @count = 0
    @products.each do |p|
      if p.counts.last.present?
        @count += p.counts.last.count
      end
    end

    @price = 0
    @products.each do |p|
      if p.counts.last.present?
        @price += p.counts.last.count * p.price
      end
    end

    # 7일간 판매 평균 계산

    @average = []

    for i in 0..2 do
      sum = []
      @products.each do |p|
        if p.counts.where(date: Date.today - (7*(i+1)) - 1).present?
          for j in (7*i+1)..(7*i+7) do
            date = p.counts.last.date

            # 초기값 세팅 : 0
            if sum[p.id].nil?
              sum[p.id] = 0
            end

            sum[p.id] = sum[p.id] + p.counts.where(date: (date.to_date - j + 1).to_s).take.buffer + p.counts.where(date: (date.to_date - j).to_s).take.count - p.counts.where(date: (date.to_date - j + 1).to_s).take.count
          end
        else
          # 신제품의 경우 무조건 0
          sum[p.id] = 0
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
      if p.counts.where(date: Date.today - 7).present?
        if @average[0][p.id] != 0
          @sell[p.id] = p.counts.last.count/@average[0][p.id]
        else
          @sell[p.id] = "-"
        end
      else
        @sell[p.id] = "-"
      end
    end

    @total = [0, 0, 0]

    for i in 0..2 do
      @products.each do |p|
        @total[i] += @average[i][p.id] * p.price
      end
    end

    # 판매 비중 (일주일 기준)
    @ratio = []
    @products.each do |p|
      @ratio[p.id] = ((@average[0][p.id] * p.price)*100).to_f/@total[0]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @products }
    end
  end

  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @product }
    end
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to products_path }
        format.xml  { render xml: @product, status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update(product_params)
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to products_list_path }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def raw
    @products = Product.all
    @count = Count.all
    @date = 31 # 31일 기준

    # 입력을 못했을 경우 빈칸
    @diff = Date.today - Count.last.date.to_date
  end

  def all
    @products = Product.all
    @count = Count.all
    @all = Date.today - ("2017-05-22").to_date + 1  # 총 날짜 수

    # 입력을 못했을 경우 빈칸
    @diff = Date.today - Count.last.date.to_date
  end

  def list
    @products = Product.all
  end

  # require 'imgkit'
  def pre_view
    # html = 'http://' + request.domain + ':3000/products/pre_view'
    # kit = IMGKit.new(html, :quality => 80) # 이미지의 화질 및 용량 결정(80%)
    # f = File.new(Rails.root.join('app','assets','images','preview.png'), 'wb')
    # img = kit.to_img(:png)
    # send_data(img.to_jpg, :type=>"image/jpeg", :disposition=>'inline')
    # f.write(img)
    # f.close
    # kit = IMGKit.new(File.new(Rails.root.join('app', 'views', 'products', 'pre_view.html.erb')), :quality => 50)    
    # file = kit.to_file('preview.png')
    render 'pre_view'
  end

  def empty
    @product = Product.find(params[:id])
    if @product.empty
      @product.update(empty: false)
    else
      @product.update(empty: true)
    end

    respond_to do |format|
      format.html { redirect_to products_path }
      format.xml  { render xml: @products }
    end
  end

  def imagecrop
    @file = params[:image_file]
    # image = MiniMagick::Image.open(@file)
    # image.crop "260x112!+0+0"
    # image.write 'image.jpg'
    # system("open image.jpg")
    @crop_width = params[:width]
    @crop_height = params[:height]
    redirect_to action: 'list'
  end


  private

  def product_params
    params.require(:product).permit(:name, :code, :kind, :price, :date, :filename, :image, :product_detail)
  end
end
