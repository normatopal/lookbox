class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google
    user = User.from_omniauth(request.env["omniauth.auth"])
    I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
    if user.persisted?
      #UserMailer.google_user_site_password(user, 'user_password').deliver_later
      flash[:notice] = 'You can access your account by password which has been sent to your email.' if try_chain { user.previous_changes[:id].any? }
      sign_in_and_redirect user
    else
      redirect_to new_user_registration_url
    end
  end

  def localized
    session[:omniauth_login_locale] = I18n.locale
    redirect_to omniauth_authorize_path(params[:provider])
  end

end