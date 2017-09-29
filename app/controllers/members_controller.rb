class MembersController < ApplicationController
  def index
    members = Member.all.order(id: :desc)
    params[:email].present? && members = members.where(email: params[:email]).all
    params[:start_date].present? && members = members.where("date >= ?", params[:start_date]).all
    params[:end_date].present? && members = members.where("date <= ?", params[:end_date]).all
    params[:start_regram_date].present? && members = members.joins(:regrams).where("regrams.date >= ?", params[:start_regram_date]).all
    params[:end_regram_date].present? && members = members.joins(:regrams).where("regrams.date <= ?", params[:end_regram_date]).all
    params[:start_rocket].present? && members = members.where("rocket >= ?", params[:start_rocket]).all
    params[:end_rocket].present? && members = members.where("rocket <= ?", params[:end_rocket]).all
    params[:from_regram].present? && members = members.select{ |m| m.regrams.count >= params[:from_regram].to_i }
    params[:to_regram].present? && members = members.select{ |m| m.regrams.count <= params[:to_regram].to_i }

    @members = members.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @memberss }
    end
  end

  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @member }
    end
  end

  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        flash[:notice] = 'Member was successfully created.'
        format.html { redirect_to(edit_member_path(@member)) }
        format.xml  { render xml: @member, status: :created, location: @member }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @member = Member.find(params[:id])
    @before = @member.befores.last.present? ? @member.befores.last.email : nil
    @count = @member.regrams.count
    @date = @member.regrams.last.present? ? @member.regrams.last.date : nil
  end

  def update
    @member = Member.find(params[:id])

    if @member.email != params[:member][:email]
      Before.create(email: @member.email, member_id: params[:id])
    end

    respond_to do |format|
      if @member.update(member_params)
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(edit_member_path(@member)) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @member.errors, status: :unprocessable_entity }
        puts @member.errors.full_messages
      end
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

  private

  def member_params
    params.require(:member).permit(:email, :before, :rocket, :name, :date, :permit, :comment, :follower, :active)
  end

end
