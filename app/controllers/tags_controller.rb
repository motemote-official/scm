class TagsController < ApplicationController
  def index
    tags = Tag.all.order(id: :desc)
    @tags = tags.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @tagss }
    end
  end

  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @tag }
    end
  end

  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to edit_tag_path(@tag) }
        format.xml  { render xml: @tag, status: :created, location: @tag }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update(tag_params)
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to edit_tag_path(@tag) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_path }
      format.xml  { head :ok }
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:title, :content, :category)
  end

end
