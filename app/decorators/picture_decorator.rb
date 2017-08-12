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
    object.image.url.present? ? image_url_with_timestamp(object.image.thumb.url, object.image_timestamp) : 'no_image_found.jpg'
  end

  def preview_image_large
    object.image.url.present? ? image_url_with_timestamp(object.image.url, object.image_timestamp) : 'no_image_found_large.jpg'
  end

  private

  def image_url_with_timestamp(url, image_timestamp)
    image_timestamp.present? ? (url + "?timestamp=" + image_timestamp.to_s) : url
  end

end