class LookDecorator < Draper::Decorator
  delegate_all

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def preloaded_look_pictures
    object.look_pictures.includes(:picture)
  end

  def available_pictures
    object.user.pictures - object.pictures
  end

  def preview_image
    object.screen.present? && object.screen.image.url ? object.screen.image.thumb : 'no_image_found.jpg'
  end

end