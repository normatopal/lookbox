class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :set_default_per_page
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  def try_chain
    yield
  rescue NoMethodError
    nil
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :current_password, :birth_date])
  end

  def set_default_per_page
    @kaminari_per_page = Kaminari.config.default_per_page
  end


  def set_locale
    I18n.locale = try_chain { current_user.user_setting.locale.name } || I18n.default_locale
  end

end
