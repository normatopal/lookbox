module LooksHelper

  def look_id_for_pictures_search
    params[:look_id] || 0
  end

end
