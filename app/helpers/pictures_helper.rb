module PicturesHelper
  def original_image_rotation(rotation)
    Rails.application.secrets.use_cloudinary && rotation ? rotation : 0
  end
end
