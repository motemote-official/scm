class FacebooksController < ApplicationController
  def index
    facebooks = Facebook.all.order(id: :desc)
    @facebooks = facebooks.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @facebooks }
    end
  end

  def new
    @facebook = Facebook.new
    10.times do |a|
      @facebook.fb_pics.build
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @facebook }
    end
  end

  def create
    @facebook = Facebook.new(facebook_params)

    respond_to do |format|
      if @facebook.save
        flash[:notice] = 'Facebook was successfully created.'
        format.html { redirect_to(edit_facebook_path(@facebook)) }
        format.xml  { render xml: @facebook, status: :created, location: @facebook }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @facebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @facebook = Facebook.find(params[:id])
  end

  def update
    @facebook = Facebook.find(params[:id])

    respond_to do |format|
      if @facebook.update(facebook_params)
        flash[:notice] = 'Facebook was successfully updated.'
        format.html { redirect_to(edit_facebook_path(@facebook)) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @facebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facebook = Facebook.find(params[:id])
    @facebook.destroy

    respond_to do |format|
      format.html { redirect_to(facebooks_url) }
      format.xml  { head :ok }
    end
  end

  private

  def facebook_params
    params.require(:facebook).permit(fb_pics_attributes: [:user_name, :id, :img, :img_cache, :_destroy])
  end
end
