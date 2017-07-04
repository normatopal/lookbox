class UserMailer < ApplicationMailer
  def google_user_site_password(user, pswd)
    @user, @pswd = user, pswd
    mail(to: @user.email, subject: "Lookbox new login password")
  end
end
