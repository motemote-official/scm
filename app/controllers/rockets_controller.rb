class RocketsController < ApplicationController
  def index
    @rockets = Rocket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rocketss }
    end
  end
end
