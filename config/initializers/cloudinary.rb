Cloudinary.config do |config|
  config.secure = true if Rails.env.production?
end