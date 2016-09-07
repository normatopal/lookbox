class LooksController < ApplicationController

  before_action :set_look, only: [:show, :edit, :update, :destroy, :available_pictures, :add_pictures]

  def index
    @looks = current_user.looks
  end

  def new
    @look = current_user.looks.new.decorate
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @look = current_user.looks.new(look_params)
    if @look.save
      redirect_to looks_path, notice: 'Look was successfully created.'
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if @look.update(look_params)
      redirect_to looks_path, notice: 'Look was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @look.destroy
    redirect_to categories_path, notice: 'Look was successfully destroyed.'
  end

  def available_pictures
    @available_pictures = current_user.pictures.available_for_look(params[:id])
  end

  def add_pictures
    @extra_pictures = current_user.pictures.where("id in (?)", look_params[:picture_ids])
  end

  private

  def set_look
    @look = params[:id].eql?("0") ? current_user.looks.new.decorate : current_user.looks.find(params[:id]).decorate
  end

  def look_params
    params.require(:look).permit(:name, :description, picture_ids: [], look_pictures_attributes: [:position_top, :position_left, :id])
  end

end