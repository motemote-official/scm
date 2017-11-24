class RocketMembersController < ApplicationController
  def index
    @rocket_members = RocketMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rocket_members }
    end
  end

  def new
    @rocket_member = RocketMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @rocket_member }
    end
  end

  def create
    @rocket_member = RocketMember.new(rocket_member_params)

    respond_to do |format|
      if @rocket_member.save
        flash[:notice] = 'RocketMember was successfully created.'
        format.html { redirect_to edit_rocket_member_path(@rocket_member) }
        format.xml  { render xml: @rocket_member, status: :created, location: @rocket_member }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @rocket_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @rocket_member = RocketMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @rocket_member }
    end
  end

  def edit
    @rocket_member = RocketMember.find(params[:id])
  end

  def update
    @rocket_member = RocketMember.find(params[:id])

    respond_to do |format|
      if @rocket_member.update(rocket_member_params)
        flash[:notice] = 'RocketMember was successfully updated.'
        format.html { redirect_to(edit_rocket_member_path(@rocket_member)) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @rocket_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rocket_member = RocketMember.find(params[:id])
    @rocket_member.destroy

    respond_to do |format|
      format.html { redirect_to(rocket_path(params[:rocket_id])) }
      format.xml  { head :ok }
    end
  end

  private

  def rocket_member_params
    params.require(:rocket_member).permit(:email, :name, :identity, :follower, :group, :homepage, :rocket_id, :product_id, :application)
  end
end
