Ransack.configure do |config|
  config.sanitize_custom_scope_booleans = false # prevent converting '1' into 'true'
end