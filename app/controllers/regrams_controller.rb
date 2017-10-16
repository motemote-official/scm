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

    # Date & Time
    now_date = Date.today.in_time_zone("Seoul").to_s
    now_time = Time.now.in_time_zone("Seoul").strftime("%H")
    times = Timepool.all.pluck(:time)

    for i in 0..(times.count - 1) do
      if now_time.to_i < times[i].to_i
        time_id = Timepool.where(time: times[i]).take.id
        time_index = i
        break
      end
    end

    if Regram.where(date: now_date).where(timepool_id: time_id).present?
      for i in (time_index + 1)..(Timepool.all.count - 1) do
        unless Regram.where(date: now_date).where(timepool_id: Timepool.where(time: times[i]).take.id).present?
          date = now_date
          time = Timepool.where(time: times[i]).take.id
          break
        end
      end

      if date.nil? || time.nil?
        for i in 0..100 do
          for j in 0..(Timepool.count - 1) do
            if Regram.where(date: (Date.today + i + 1).to_s).where(timepool_id: Timepool.where(time: times[j]).take.id).take.nil?
              date = (Date.today + i + 1).to_s
              time = Timepool.where(time: times[j]).take.id
              break
            end
          end
        end
      end
    else
      date = now_date
      time = time_id
    end

    params[:id].nil? ? @member = nil : @member = Member.find(params[:id])
    params[:date].nil? ? @date = date.to_date : @date = params[:date]
    params[:time].nil? ? @time = time : @time = Timepool.where(time: params[:time]).take.id

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

    respond_to do |format|
      if @regram.update(member_id: Member.where(email: params[:regram][:member_id]).take.id,
                        date: params[:regram][:date],
                        content: params[:regram][:content],
                        img: params[:regram][:img],
                        url: params[:regram][:url],
                        product_id: params[:regram][:product_id],
                        timepool_id: params[:regram][:timepool_id])
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

    if params[:val].present?
      if type == "user-tag"
        render json: { text: "\n-\nfrom @#{val}" }
      else
        render json: { text: "\n-\n#{Tag.find(val).content}" }
      end
    else
      render json: { text: "\n-\nfrom @#{params[:val1]}\n-\n#{Tag.find(params[:val2]).content}\n-\n#{Tag.find(params[:val3]).content}" }
    end
  end

  private

  def regram_params
    params.require(:regram).permit(:date, :content, :img, :url, :member_id, :product_id, :timepool_id)
  end
end
