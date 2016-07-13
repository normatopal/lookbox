class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  #respond_to :html, :js

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1
  # GET /pictures/1.json
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
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = current_user.pictures.new(picture_params)
    respond_to do |format|
      if @picture.valid?
        format.html { redirect_to pictures_path, notice: 'Picture was successfully created.' }
        -#format.js { render :show }
        format.js { redirect_to pictures_path, notice: 'Picture was successfully created.' }
      else
        format.html { render :new }
        format.js { render :new }
      end
    end

  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.js { render :show }
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:title, :description, :user_id, :image)
    end
end
