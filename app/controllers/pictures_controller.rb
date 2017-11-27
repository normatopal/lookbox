class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :search_pictures, only: [:index]
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
    @picture.find_previous_next_pictures(session[:picture_ids_list])
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
    @picture = current_user.pictures.new(picture_params).decorate
    respond_to do |format|
      if @picture.save
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
      if @picture.update(picture_params)
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

  private
  
    def set_picture
      @picture = current_user.pictures.find(params[:id]).decorate
    end

    def search_pictures
      # search_params = params[:q]
      # Picture.switch_subcategories_flag(search_params)
      # @look_id, @category_id = params[:look_id], params[:category_id]
      # @search = current_user.pictures.search(search_params)
      # current_pictures = @search.result.where.not(id: cookies[:look_pictures_ids].split(',')) if @look_id
      # current_pictures = @search.result.available_for_category(@category_id) if @category_id
      # current_pictures ||= @search.result
      # #@pictures = Rails.cache.fetch('pictures/' + current_pictures.map(&:id).join(',')) do
      # @pictures = paginate_pictures(current_pictures, (@look_id || @category_id) ? 5 : @kaminari_per_page)
      # session[:picture_ids_list] = current_pictures.map(&:id)

    end

    def paginate_pictures(pictures, per_page)
      Kaminari.paginate_array(PictureDecorator.wrap(pictures)).page(params[:page]).per(per_page)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h, :title, :description, :rotation, :user_id, :image, category_ids: [])
    end

end
