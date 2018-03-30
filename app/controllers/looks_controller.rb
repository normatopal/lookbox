class LooksController < ApplicationController

  before_action :set_look, only: [:new, :show, :edit, :update, :destroy, :add_pictures]
  before_action :set_look_screen, only: [:new, :edit]
  before_action :reset_look_pictures, only: [:new, :edit]

  set_tab :looks_list, :only => %w(index)
  set_tab :looks_shared, :only => %w(shared)

  autocomplete :user, :email, :extra_data => [:id]

  include SearchFilter

  def get_autocomplete_items(parameters)
    #items = super(parameters) #rails4-autocomplete
    #items = active_record_get_autocomplete_items(parameters) #rails-jquery-autocomplete
    active_record_get_autocomplete_items(parameters).select{|user| !user.eql?(current_user)}.presence || [OpenStruct.new(id: '', parameters[:method].to_s => 'nothing found')]
  end

  def index
    @search, @looks = filtered_looks(current_user.looks, params)
  end

  def shared
    @search, @looks = filtered_looks(current_user.shared_looks.with_approved(current_user.id), params)
    render "index", locals: {is_shared_looks: true}
  end

  def approve_shared
    user_look = UserLook.find_user_look(current_user.id, params[:id])
    if user_look && user_look.update(is_approved: true)
      redirect_to shared_looks_path, notice: 'Shared look was successfully approved.'
    else
      redirect_to shared_looks_path, notice: 'You can\'t approve this sharing.'
    end
  end

  def remove_shared
    user_look = UserLook.find_user_look(current_user.id, params[:id])
    if user_look.delete
      redirect_to shared_looks_path, notice: 'Shared look was declined. It\'s owner was notified'
    else
      redirect_to shared_looks_path, notice: 'You can\'t decline this sharing.'
    end
  end

  def new

  end

  def create
    @look = current_user.looks.new(look_params).decorate
    if @look.save
      @look.decode_screen_image(look_params[:screen_attributes][:image_encoded])

      @look.save if @look.changed?
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

  def add_pictures
    extra_pictures = current_user.pictures.where("id in (?)", look_params[:picture_ids])
    all_extra_pictures_ids = cookies[:look_pictures_ids].split(",") + extra_pictures.ids
    cookies[:look_pictures_ids] = all_extra_pictures_ids.join(',')
    @all_extra_pictures_count = all_extra_pictures_ids.count
    @extra_look_pictures = extra_pictures.map{|p| p.look_pictures.build(look_id: params[:id]) }
  end

  private

  def set_look
    @look = ['0', nil].include?(params[:id]) ? current_user.looks.new.decorate : current_user.looks.find(params[:id]).decorate
  end

  def set_look_screen
    @look.screen = current_user.pictures.new if @look.present? && @look.screen.blank?
  end

  def reset_look_pictures
    cookies[:look_pictures_ids] = @look.pictures.ids.join(',')
  end

  def look_params
    params.require(:look).permit(:name, :description, picture_ids: [], look_pictures_attributes: [:top, :left, :width, :height, :order, :picture_id, :id, :_destroy],
            screen_attributes: [:id, :title, :user_id, :image_encoded], user_looks_attributes: [:id, :user_id, :_destroy])
  end

end
