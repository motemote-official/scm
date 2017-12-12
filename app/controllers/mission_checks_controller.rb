class MissionChecksController < ApplicationController
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/poltergeist'

  include Capybara::DSL

  def new
    @rocket = Rocket.find(params[:rocket_id])
    @mission = @rocket.missions.where("date <= ?", Date.today).last
    if params[:mission_id].present? && params[:rocket_member_id].present?
      @member = RocketMember.where(id: params[:rocket_member_id]).first(1).paginate(page: params[:page], per_page: 4)
      @date = Mission.find(params[:mission_id]).date
    else
      @member = @rocket.rocket_members.all.paginate(page: params[:page], per_page: 4)
    end

    Capybara.default_driver = :poltergeist

    @img = []
    @url = []
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
      format.html # new.html.erb
      format.xml  { render xml: @mission_check }
    end
  end

  def create
    @mission = Mission.find(params[:mission_id])
    @rocket = @mission.rocket
    @rocket_member = RocketMember.find(params[:rocket_member_id])
    @mission_check =  MissionCheck.where(rocket_member_id: params[:rocket_member_id], mission_id: params[:mission_id])
    if params[:status] == "0"
      if @mission_check.present?
        @mission_check.take.destroy
      end
    else
      unless @mission_check.present?
        @mission_check = MissionCheck.create(rocket_member_id: params[:rocket_member_id], mission_id: params[:mission_id])
      end
    end
  end

  def change
    @rocket = Rocket.find(params[:rocket_id])
    @prev_mission = Mission.find(params[:mission_id])
    @next_mission = Mission.find(params[:value].to_i)
    @rocket_member = RocketMember.find(params[:rocket_member_id])

    respond_to do |format|
      format.js { render "change.js.erb" }
    end
  end
end
