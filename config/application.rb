require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scheduler
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << "#{Rails.root}/app/inputs"
    config.autoload_paths << "#{Rails.root}/app/policies"
    config.autoload_paths << "#{Rails.root}/app/presenters"

    config.i18n.load_path = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
  end
end
