class RocketApplyController < ApplicationController
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'

  include Capybara::DSL

  def index
    @rockets = Rocket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rocket }
    end
  end

  def show
    @rocket = Rocket.find(params[:id])
    @date = params[:date].nil? ? (Date.today - 1) : params[:date]
    if params[:type].nil?
      @identity = @rocket.rocket_members.all.pluck(:identity).uniq
    else
      @identity = @rocket.rocket_members.where(pass: params[:type]).all.pluck(:identity).uniq
    end

    Capybara.default_driver = :poltergeist

    @img = []
    @url = []
    @followers = []

    per_page = 5

    if params[:type] == "pass"
      @member = @rocket.rocket_members.pass.all
    elsif params[:type] == "hold"
      @member = @rocket.rocket_members.hold.all
    else
      @member = @rocket.rocket_members.all
    end

    unless params[:identity].nil?
      @member = @member.where(identity: params[:identity]).all
    end

    @member = @member.paginate(page: params[:page], per_page: per_page)

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
      if first("body main article header section ul li:nth-child(2)").present?
        @followers << find("body main article header section ul li:nth-child(2)").text().split(" ")[0]
      else
        @followers << 0
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @rocket }
    end
  end

  def pass
    @rocket_member = RocketMember.find(params[:id])
    @rocket_member.update(pass: params[:pass])

    render json: { id: params[:id], pass: params[:pass] }
  end

  def excel
    @rocket = Rocket.find(params[:id])
    if params[:instagram].nil?
      @member = @rocket.rocket_members.all.paginate(page: params[:page], per_page: 20)
    else
      @member = @rocket.rocket_members.where("email like ?", "%#{params[:instagram]}%").paginate(page: params[:page], per_page: 20)
    end
  end
end
