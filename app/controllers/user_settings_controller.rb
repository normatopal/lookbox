class UserSettingsController < ApplicationController
  before_action :set_user_setting

  def change

  end

  def save
    if @user_setting.update(user_setting_params)
      redirect_to root_path, notice: 'Settings were successfully saved.'
    else
      render :change
    end
  end

  private

  def set_user_setting
    @user_setting = current_user.user_setting || UserSetting.new(locale: Locale.default_locale, user: current_user)
  end

  def user_setting_params
    params.require(:user_setting).permit(:timezone, :locale_id, :time_zone)
  end

end