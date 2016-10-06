class LooksController < ApplicationController

  before_action :set_look, only: [:new, :show, :edit, :update, :destroy, :available_pictures, :add_pictures]
  before_action :set_look_screen, only: [:new, :edit]
  before_action :reset_look_pictures, only: [:new, :edit]

  def index
    @looks = LookDecorator.wrap(current_user.looks)
  end

  def new

  end

  def create
    @look = current_user.looks.new(look_params).decorate
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
    @look.decode_screen_image(look_params[:screen_attributes][:image_encoded])
    if @look.update(look_params)
      redirect_to looks_path, notice: 'Look was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @look.destroy
    redirect_to looks_path, notice: 'Look was successfully destroyed.'
  end

  def available_pictures
    @available_pictures = current_user.pictures.where.not(id: cookies[:look_pictures_ids].split(','))
  end

  def add_pictures
    @extra_pictures = current_user.pictures.where("id in (?)", look_params[:picture_ids])
    all_extra_pictures_ids = cookies[:look_pictures_ids].split(",") + @extra_pictures.ids
    cookies[:look_pictures_ids] = all_extra_pictures_ids.join(',')
    @all_extra_pictures_count = all_extra_pictures_ids.count
    @extra_look_pictures = @extra_pictures.map{|p| p.look_pictures.build(look_id: params[:id]) }
  end

  private

  def set_look
    @look = ["0", nil].include?(params[:id]) ? current_user.looks.new.decorate : current_user.looks.find(params[:id]).decorate
  end

  def set_look_screen
    @look.screen = current_user.pictures.new if @look.present? && @look.screen.blank?
  end

  def reset_look_pictures
    cookies[:look_pictures_ids] = @look.pictures.ids.join(",")
  end

  def look_params
    params.require(:look).permit(:name, :description, picture_ids: [], look_pictures_attributes: [:position_top, :position_left, :position_order, :picture_id, :id, :_destroy], screen_attributes: [:id, :title, :user_id, :image_encoded])
  end

end