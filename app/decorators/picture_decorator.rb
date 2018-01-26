class PictureDecorator < Draper::Decorator
  delegate_all

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def preview_image_large
    object.image && object.image.large.url || 'no_image_found_large.jpg'
  end

end