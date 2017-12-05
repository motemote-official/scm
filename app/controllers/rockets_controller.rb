class RocketsController < ApplicationController
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'

  include Capybara::DSL

  def index
    @rockets = Rocket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rocketss }
    end
  end

  def new
    @rocket = Rocket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @rocket }
    end
  end

  def create
    @rocket = Rocket.new(rocket_params)

    respond_to do |format|
      if @rocket.save
        flash[:notice] = 'Rocket was successfully created.'
        format.html { redirect_to rockets_path }
        format.xml  { render xml: @rocket, status: :created, location: @rocket }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @rocket.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @rocket = Rocket.find(params[:id])
    @start_date = @rocket.start_date.to_date

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @rocket }
    end
  end

  def calendar
    @rocket = Rocket.find(params[:id])
    @count = @rocket.rocket_members.count

    respond_to do |format|
      format.html # calendar.html.erb
      format.xml { render xml: @rocket }
    end
  end

  def edit
    @rocket = Rocket.find(params[:id])
  end

  def update
    @rocket = Rocket.find(params[:id])

    respond_to do |format|
      if @rocket.update(rocket_params)
        flash[:notice] = 'Rocket was successfully updated.'
        format.html { redirect_to rockets_path }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @rocket.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rocket = Rocket.find(params[:id])
    @rocket.destroy

    respond_to do |format|
      format.html { redirect_to(rockets_url) }
      format.xml  { head :ok }
    end
  end

  def attend
    @rocket = Rocket.find(params[:id])
    @date = params[:date].nil? ? (Date.today - 1) : params[:date]

    Capybara.default_driver = :poltergeist

    @img = []
    @url = []
    @member = @rocket.rocket_members.all.paginate(page: params[:page], per_page: 4)
    @member.pluck(:email).each_with_index do |m, index|
      visit "https://www.instagram.com/" + m + "/"
      sleep 1

      item = []
      href = []
      all(:css, 'img').each do |i|
        if item.count < 5
          item << i['src']
          #img = i['src'].split('/')
          #if img.count == 9
            #item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[8]}"
          #else
            #item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[7]}"
          #end
        end

        url = i.find(:xpath, '../../..')['href']
        href << url
      end
      item -= [item[0]]
      href -= [href[0]]

      @img << item
      @url << href
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @model_class_names }
    end
  end

  def attend_show
    @rocket = Rocket.find(params[:id])
    @date = params[:date].nil? ? (Date.today - 1) : params[:date].to_date

    Capybara.default_driver = :poltergeist

    @img = []
    @url = []
    @member = RocketMember.find(params[:member_id])
    visit "https://www.instagram.com/" + @member.email + "/"

    item = []
    href = []
    all(:css, 'img').each do |i|
      if item.count < 5
        item << i['src']
        #img = i['src'].split('/')
        #if img.count == 9
          #item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[8]}"
        #else
          #item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[7]}"
        #end
      end

      url = i.find(:xpath, '../../..')['href']
      href << url
    end
    item -= [item[0]]
    href -= [href[0]]

    @img = item
    @url = href

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @model_class_names }
    end

  end

  def absent
    @rocket = Rocket.find(params[:id])
    @date = params[:date].nil? ? (Date.today-1) : params[:date]

    Capybara.default_driver = :poltergeist

    @img = []
    @url = []
    ids = []
    @rocket.rocket_members.all.each do |m|
      if m.attends.where(date: Date.today - 1).present?
        unless m.attends.where(date: Date.today - 1).take.status == "attendance"
          ids << m.id
        end
      else
        ids << m.id
      end
    end
    p ids
    @member = RocketMember.where(id: ids).all.paginate(page: params[:page], per_page: 4)
    @member.pluck(:email).each_with_index do |m, index|
      visit "https://www.instagram.com/" + m + "/"
      sleep 1

      item = []
      href = []
      all(:css, 'img').each do |i|
        if item.count < 5
          item << i['src']
        end

        url = i.find(:xpath, '../../..')['href']
        href << url
      end
      item -= [item[0]]
      href -= [href[0]]

      @img << item
      @url << href
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @model_class_names }
    end
  end

  def check
    #date = params[:attend]
    #@date = Date.new date["date(1i)"].to_i, date["date(2i)"].to_i, date["date(3i)"].to_i
    @date = Date.new params[:date1].to_i, params[:date2].to_i, params[:date3].to_i
    @rocket_member = RocketMember.find(params[:id])

    if @rocket_member.attends.where(date: @date).present?
      @attend = @rocket_member.attends.where(date: @date).take
      @attend.update(status: params[:status].to_i)
    else
      @attend = @rocket_member.attends.create(rocket_id: params[:rocket_id],
                                              status: params[:status].to_i,
                                              date: @date)
    end

    render json: {id: params[:id], status: params[:status]}
  end

  def regram_index
    @regrams = Regram.all
    @today = Date.today
    @dayofweek = @today.wday
    @timepool = [17, 22, 23, 24]
    @rocket= Rocket.find(params[:id])

    respond_to do |format|
      format.html { render 'rockets/regrams/index.html.erb' }
      format.xml  { render xml: @regramss }
    end
  end

  def regram_new
    @regram = RocketRegram.new
    @regram.rocket_pics.build
    @rocket = Rocket.find(params[:id])
    @date = params[:date]
    @time = params[:time]

    respond_to do |format|
      format.html { render 'rockets/regrams/new.html.erb' }
      format.xml  { render xml: @regram }
    end
  end

  private

  def rocket_params
    params.require(:rocket).permit(:unit, :term, :start_date, :end_date, :volume)
  end
end
