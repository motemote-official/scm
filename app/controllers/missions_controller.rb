class MissionsController < ApplicationController
  def index
    @rocket = Rocket.find(params[:rocket_id])
    @missions = @rocket.missions.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @missions }
    end
  end

  def new
    @rocket = Rocket.find(params[:rocket_id])
    @mission = @rocket.missions.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @mission }
    end
  end

  def create
    @rocket = Rocket.find(params[:rocket_id])
    @mission = @rocket.missions.new(mission_params)

    respond_to do |format|
      if @mission.save
        flash[:notice] = 'Mission was successfully created.'
        format.html { redirect_to edit_rocket_path(@rocket) }
        format.xml  { render xml: @mission, status: :created, location: @mission }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @mission = Mission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @mission }
    end
  end

  def edit
    @mission = Mission.find(params[:id])
    @rocket = @mission.rocket
  end

  def update
    @mission = Mission.find(params[:id])

    respond_to do |format|
      if @mission.update(mission_params)
        flash[:notice] = 'Mission was successfully updated.'
        format.html { redirect_to(@mission) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mission = Mission.find(params[:id])
    @rocket = @mission.rocket
    @mission.destroy

    respond_to do |format|
      format.html { redirect_to edit_rocket_path(@rocket) }
      format.xml  { head :ok }
    end
  end

  private

  def mission_params
    params.require(:mission).permit(:content, :date, :rocket_id)
  end
end
