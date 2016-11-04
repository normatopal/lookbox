class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :set_default_per_page

  def set_default_per_page
    @kaminari_per_page = Kaminari.config.default_per_page
  end

end
