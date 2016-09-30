class LooksController < ApplicationController

  before_action :set_look, only: [:show, :edit, :update, :destroy, :available_pictures, :add_pictures]
  before_action :reset_look_pictures, only: [:new, :edit]

  def index
    @looks = LookDecorator.wrap(current_user.looks)
  end

  def new
    @look = current_user.looks.new.decorate
    respond_to do |format|
      format.html
      format.js
    end
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
    @look.screen = current_user.pictures.new if @look.screen.blank?
  end

  def update
    @look.screen = current_user.pictures.new if @look.screen.blank?
    screen_image = @look.get_image_from_str(look_params[:screen_attributes][:image_encoded])
    @look.screen.image = screen_image
    begin
      if @look.update(look_params)
        redirect_to looks_path, notice: 'Look was successfully updated.'
      else
        render :edit
      end
    ensure
      #screen_image.close
      #screen_image.unlink
    end

  end

  def destroy
    @look.destroy
    redirect_to looks_path, notice: 'Look was successfully destroyed.'
  end

  def available_pictures
    @available_pictures = current_user.pictures.where.not(id: cookies[:look_pictures_ids].split(','))
    #@extra_picture_ids = cookies[:extra_pictures].split(',')
  end

  def add_pictures
    @extra_pictures = current_user.pictures.where("id in (?)", look_params[:picture_ids])
    added_extra_pictures_array = cookies[:look_pictures_ids].split(",")
    cookies[:look_pictures_ids] = (added_extra_pictures_array + @extra_pictures.ids).join(',')
    @all_extra_pictures_count = @look.pictures.count + added_extra_pictures_array.count
    @extra_look_pictures = @extra_pictures.map{|p| p.look_pictures.build(look_id: params[:id]) }
  end

  private

  def set_look
    @look = params[:id].eql?("0") ? current_user.looks.new.decorate : current_user.looks.find(params[:id]).decorate
  end

  def reset_look_pictures
    cookies[:look_pictures_ids] = @look.pictures.ids.join(",")
  end

  def look_params
    params.require(:look).permit(:name, :description, picture_ids: [], look_pictures_attributes: [:position_top, :position_left, :picture_id, :id], screen_attributes: [:id, :title, :user_id, :image_encoded])
  end

end