module HomeHelper
  def current_user_name
    current_user && current_user.name ? current_user.name : "friend"
  end
end
