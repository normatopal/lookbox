class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :index
  #respond_to :html, :js

  # GET /pictures
  def index
    search_pictures
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_pictures
    @search = current_user.pictures.search(params[:q])
    @pictures = @search.result.page(params[:page]) #.per(10)
  end

  # GET /pictures/1
  def show

  end

  # GET /pictures/new
  def new
    @picture = current_user.pictures.new
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
    @picture = current_user.pictures.new(picture_params)
      if @picture.save
        redirect_to pictures_path, notice: 'Picture was successfully added.'
      else
        render :new
      end
  end

  # PATCH/PUT /pictures/1
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        flash[:notice] = "You have successfully !!!"
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.js { redirect_to pictures_path, notice: 'Picture was successfully updated.' }
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

  private
    def set_picture
      @picture = current_user.pictures.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:title, :description, :user_id, :image, category_ids: [])
    end
end
