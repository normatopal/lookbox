class UsersController < ApplicationController
  include Devise::Controllers::Helpers

  def profile
    redirect_to root_path
  end

  def change_password
    @user = current_user
  end

  def save_password
      @user = current_user
      if @user.update_password_with_new(user_params)
        # Sign in the user by passing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to root_path, flash: { success: "Successfully updated password" }
      else
        render "change_password"
      end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

end
