# encoding: utf-8

class CloudinaryUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  include Cloudinary::CarrierWave

  process optimize: [{ quality: 80 }]

  def public_id
    "#{Rails.application.secrets.cloudinary_folder || 'public'}/users/#{model.user.id}/pict_#{model.id}_#{model.updated_at.to_i}"
  end

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
            transformation: [ cropper, { width: 150, height: 150, crop: 'fill' }, rotation ] # lfill - not resize smaller images
    }
  end

  def transform_large
    {
            transformation: [ cropper, rotation ]
    }
  end

  # Create different versions of your uploaded files:

  version :large do
    process :transform_large
  end

  version :thumb do
    #cloudinary_transformation transformation: [{width: 150, height: 150, crop: 'fill'}]
    process :transform_thumb
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
