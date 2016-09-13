class LookDecorator < Draper::Decorator
  delegate_all

  def preloaded_pictures
    object.pictures.includes(:look_pictures)
  end

  def available_pictures
    object.user.pictures - object.pictures
  end


end