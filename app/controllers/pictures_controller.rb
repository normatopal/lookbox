class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :search_pictures, only: [:index]
  protect_from_forgery except: :index
  #respond_to :html, :js

  # GET /pictures
  def index
    respond_to do |format|
      format.html do
        flash[:notice] = 'Picture was successfully added.' if params[:created_id].present?
      end
      format.js do
        @look = current_user.looks.find(params[:look_id]).decorate if params[:look_id]
        @available_pictures = @search.result.where.not(id: cookies[:look_pictures_ids].split(','))
        render 'looks/available_pictures'
      end
    end
  end

  # GET /pictures/1
  def show

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
      if @picture.valid? #save
        format.html { redirect_to pictures_path, notice: 'Picture was successfully added.' }
        format.js { render :create }
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
      session[:pictures_filter] = params[:q] unless params[:q].blank?
      search_params = session[:pictures_filter]
      Picture.switch_subcategories_flag(search_params)
      @search = current_user.pictures.search(search_params)
      @pictures = Kaminari.paginate_array(PictureDecorator.wrap(@search.result)).page(params[:page]).per(@kaminari_per_page)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:title, :description, :rotation, :user_id, :image, category_ids: [])
    end

end
