class PictureDecorator < Draper::Decorator
  delegate_all

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def categories_set
    object.user.categories.collect { |cat| ["#{'-' * cat.level} #{cat.name}", cat.id] }
  end

  def preview_image
    object.image.thumb.url || 'no_image_found.jpg'
  end

  def preview_image_large
    object.image.large.url || 'no_image_found_large.jpg'
  end

end