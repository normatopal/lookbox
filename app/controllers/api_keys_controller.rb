class ApiKeysController < ApplicationController

  before_action :set_user_settings_api_key

  def recreate_access_token
    @api_key.generate_access_token
    respond_to do |format|
      format.js { render 'api_key' }
    end
  end

  private

  def set_user_settings_api_key
    @user_setting = current_user.current_user_setting
    @api_key = @user_setting.user_api_key
  end

end