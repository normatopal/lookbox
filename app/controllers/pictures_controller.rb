class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :index
  #respond_to :html, :js

  include SearchFilter

  # GET /pictures
  def index
    @search, @pictures = filtered_pictures(current_user.pictures, params)
    respond_to do |format|
      format.html { flash[:notice] = 'Picture was successfully added.' if params.delete(:created_id) }
      format.js do
        @available_pictures = @pictures
        search_view = if params[:look_id] then 'looks/available_pictures' elsif params[:category_id] then 'categories/available_pictures' else {js: 'No results was found'}  end
        render search_view
      end
    end
  end

  # GET /pictures/1
  def show
    #if stale?(last_modified: @picture.updated_at.utc, etag: @picture.cache_key)
      respond_to do |format|
        format.html
        format.js
      end
    #end
  end

  # GET /pictures/new
  def new
    @picture = current_user.pictures.new.decorate
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  def create
    @picture = current_user.pictures.new(picture_params.except(:image)).decorate
    respond_to do |format|
      if @picture.save
        @picture.image = picture_params[:image] if picture_params[:image].present?
        @picture.save if @picture.changed?
        format.html { redirect_to pictures_path, notice: 'Picture was successfully added.' }
        format.js { render text: 'window.location.reload()' }
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /pictures/1
  def update
    respond_to do |format|
      if @picture.update(picture_params) #update_attributes
        flash[:notice] = 'You have successfully updated the picture'
        format.html { redirect_to pictures_path, notice: 'Picture was successfully updated.' }
        format.js { render :update }
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
    end
  end

  def refresh
    session.delete(:pictures_filter)
    redirect_to pictures_path
  end

  def copy
    original_picture = current_user.pictures.find(params[:id])
    new_picture = original_picture.dup.decorate
    #@picture.image = original_picture.image
    new_picture.title += ' copy'
    CopyCarrierwaveFile::CopyFileService.new(original_picture, new_picture, :image).set_file
    new_picture.save
    @picture = new_picture
    respond_to do |format|
      format.html { render :show }
      format.js { render :show }
    end
  end

  private
  
    def set_picture
      @picture = current_user.pictures.find(params[:id]).decorate
    end

    def paginate_pictures(pictures, per_page)
      Kaminari.paginate_array(PictureDecorator.wrap(pictures)).page(params[:page]).per(per_page)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).transform_keys{|k| k.sub('image_crop', 'crop')}.permit(:crop_x, :crop_y, :crop_w, :crop_h, :title, :description, :rotation, :user_id, :image, category_ids: [])
    end

end
