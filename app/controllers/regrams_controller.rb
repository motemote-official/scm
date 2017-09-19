class RegramsController < ApplicationController
  def index
    @regrams = Regram.all
    @today = Date.today
    @dayofweek = @today.wday
    @timepool = Timepool.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @regramss }
    end
  end

  def new
    @regram = Regram.new
    params[:id].nil? ? @member = nil : @member = Member.find(params[:id])
    params[:date].nil? ? @date = nil : @date = params[:date]
    params[:time].nil? ? @time = nil : @time = Timepool.where(time: params[:time]).take.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @regram }
    end
  end

  def create
    @regram = Regram.new(regram_params)
    @regram.member_id = Member.where(email: params[:regram][:member_id]).take.id

    respond_to do |format|
      if @regram.save
        flash[:notice] = 'Regram was successfully created.'
        format.html { redirect_to(edit_regram_path(@regram)) }
        format.xml  { render xml: @regram, status: :created, location: @regram }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @regram.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @regram = Regram.find(params[:id])
    @member = Member.find(@regram.member_id)
    @date = @regram.date
    @time = @regram.timepool_id
  end

  def update
    @regram = Regram.find(params[:id])
    @regram.member_id = Member.where(email: params[:regram][:member_id]).take.id

    respond_to do |format|
      if @regram.save
        @regram.update(member_id: Member.where(email: params[:regram][:member_id]).take.id)
        flash[:notice] = 'Regram was successfully updated.'
        format.html { redirect_to(edit_regram_path(@regram)) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @regram.errors, status: :unprocessable_entity }
        puts @regram.errors.full_messages
      end
    end
  end

  def destroy
    @regram = Regram.find(params[:id])
    @regram.destroy

    respond_to do |format|
      format.html { redirect_to(regrams_url) }
      format.xml  { head :ok }
    end
  end

  def tag
    type = params[:type]
    val = params[:val]

    if type == "user-tag"
      render json: { text: "\n\nfrom @#{val}" }
    else
      render json: { text: "\n\n#{Tag.find(val).content}" }
    end
  end

  private

  def regram_params
    params.require(:regram).permit(:date, :content, :img, :url, :member_id, :product_id, :timepool_id)
  end
end
