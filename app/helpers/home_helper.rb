module HomeHelper
  def current_user_name
    user_signed_in? && current_user.name.present? ? current_user.name : "friend"
  end
end
