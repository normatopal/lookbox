# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  #storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "uploads/#{Rails.env.test? ? 'test/' : ''}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  # def cache_dir
  #   "uploads/#{Rails.env.test? ? 'test/' : ''}tmp"
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # process :auto_orient # this should go before all other "process" steps
  #
  # def auto_orient
  #   manipulate! do |image|
  #     image.tap(&:auto_orient)
  #   end
  # end

  process optimize: [{ quality: 80 }]

  # def rotate_img
  #   manipulate! do |img|
  #     img.rotate(model.rotation)
  #     img #returns the manipulated image
  #   end
  # end
  #
  # process :rotate_img, if: :has_rotation?

  process :generate_on_upload

  def generate_on_upload
    {
       transformation: [ cropper, rotation ]
    }
  end

  def cropper
    if model.crop_x.to_f > 0 || model.crop_y.to_f > 0
      {
        crop: 'crop',
        x: model.crop_x.to_f.round,
        y: model.crop_y.to_f.round,
        width: model.crop_w.to_f.round,
        height: model.crop_h.to_f.round
      }
    end
  end

  def rotation
    { angle: model.rotation || '0'}
  end

  def transform_thumb
    {
      transformation: [ cropper, { width: 150, height: 150, crop: 'fill' }, rotation ]
    }
  end

  def transform_large
    {
        transformation: [ cropper, rotation ]
    }
  end

  def transform_original
    { transformation: [ rotation ] }
  end

  # Create different versions of your uploaded files:

  version :original_size do
    process :transform_original
  end

  version :large do
    process :transform_large
  end

  version :thumb do
    #process :resize_to_fill => [150, 150]
    #cloudinary_transformation transformation: [{width: 150, height: 150, crop: 'fill'}]
    process :transform_thumb
  end

  # def has_rotation?
  #   model.rotation.present? && model.rotation.to_i > 0
  # end

  # def crop
  #   if model.crop_x.present?
  #     manipulate! do |img|
  #       x = model.image_crop_x.to_i
  #       y = model.image_crop_y.to_i
  #       w = model.image_crop_w.to_i
  #       h = model.image_crop_h.to_i
  #       img.crop("#{w}x#{h}+#{x}+#{y}")
  #       img
  #     end
  #   end
  # end

  # def public_id
  #   "#{model.class.to_s.underscore}-#{mounted_as}-#{model.id}"
  # end

  def public_id
    "users/#{model.user.id}/pict_#{model.id}_#{model.updated_at.to_i}"
  end

  # def make_transformation
  #   self.class.cloudinary_transformation :transformation => [
  #           { x: 150, y: 100, width: 400, heigth: 300, crop: 'crop' },
  #           { angle: model.rotation || '0'}
  #   ]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  # "something.jpg" if original_filename
  # end

end
