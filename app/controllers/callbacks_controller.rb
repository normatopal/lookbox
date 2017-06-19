class CallbacksController < Devise::OmniauthCallbacksController

  def google
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash[:notice] = 'You can access your account by password which has been sent to your email.'
      sign_in_and_redirect user
    else
      redirect_to new_user_registration_url
    end
  end

end