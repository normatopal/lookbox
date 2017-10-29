require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'autoprefixer-rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lookbox
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    #config.web_console.development_only = false

    config.encoding = 'utf-8'

    config.i18n.available_locales =  Dir["#{Rails.root}/config/locales/??.yml"].map { |d|  d.split('/').last.split('.').first }

    config.i18n.fallbacks = {'es' => 'en', 'ru' => 'en', 'fr' => 'en', 'ua' => 'en', 'de' => 'en'}
    config.i18n.enforce_available_locales = false
    config.i18n.default_locale = 'en'

    config.time_zone = 'UTC'

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'secret_tokens.yml')
        YAML.load(File.open(env_file)).try(:each) { |key, value| ENV[key.to_s] = value } if File.exists?(env_file) && !File.zero?(env_file)
    end

  end
end
