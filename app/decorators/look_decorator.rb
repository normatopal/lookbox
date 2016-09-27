class LookDecorator < Draper::Decorator
  delegate_all

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def preloaded_pictures
    object.pictures.includes(:look_pictures)
  end

  def available_pictures
    object.user.pictures - object.pictures
  end

  def preview_image
    object.screen.present? ? object.screen.image.look_small : 'no_image_found.jpg'
  end

end