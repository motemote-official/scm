class RocketRegramsController < ApplicationController
  def index
    @rocket = Rocket.find(params[:rocket_id])
    @today = Date.today
    @dayofweek = @today.wday
    @timepool = [17, 22, 23, 24]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @regramss }
    end
  end

  def new
    @rocket = Rocket.find(params[:rocket_id])
    @regram = @rocket.rocket_regrams.new
    @regram.rocket_pics.build
    @date = params[:date]
    @time = params[:time]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @regram }
    end
  end

  def create
    @regram = RocketRegram.new(rocket_regram_params)
    @regram.rocket_member_id = RocketMember.where(email: params[:rocket_regram][:rocket_member_id]).take.id
    @regram.rocket_id = params[:rocket_id]

    respond_to do |format|
      if @regram.save
        flash[:notice] = 'Regram was successfully created.'
        format.html { redirect_to(edit_rocket_regram_path(@regram)) }
        format.xml  { render xml: @regram, status: :created, location: @regram }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @regram.errors, status: :unprocessable_entity }
        puts @regram.errors.full_messages
      end
    end
  end

  def edit
    @regram = RocketRegram.find(params[:id])
    @member = RocketMember.find(@regram.rocket_member_id)
    @date = @regram.date
    @time = @regram.regram_at
    @rocket = Rocket.find(@regram.rocket_id)
  end

  def update
    @regram = RocketRegram.find(params[:id])
    rp = rocket_regram_params.merge(rocket_member_id: RocketMember.where(email: params[:rocket_regram][:rocket_member_id]).take.id)

    respond_to do |format|
      if @regram.update(rp)
        flash[:notice] = 'Regram was successfully updated.'
        format.html { redirect_to(edit_rocket_regram_path(@regram)) }
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

    if params[:val].present?
      if type == "rocket-user-tag"
        render json: { text: "\n-\nfrom @#{val}" }
      else
        render json: { text: "\n-\n#{Tag.find(val).content}" }
      end
    else
      render json: { text: "\n-\nfrom @#{params[:val1]}\n-\n#{Tag.find(params[:val2]).content}\n-\n#{Tag.find(params[:val3]).content}" }
    end
  end

  private

  def rocket_regram_params
    params.require(:rocket_regram).permit(:rocket_id, :date, :url, :content, :rocket_member_id, :product_id, :regram_at, rocket_pics_attributes: [:id, :img, :img_cache, :_destroy])
  end
end
