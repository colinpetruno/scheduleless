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
    config.autoload_paths << "#{Rails.root}/app/searches"
    config.autoload_paths << "#{Rails.root}/app/tasks"

    config.i18n.load_path = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    # Mailing Credentials
    # config.action_mailer.perform_deliveries = false

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
    config.action_mailer.default_url_options = {
      host: Rails.application.secrets.host
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      authentication: :plain,
      address: "smtp.mailgun.org",
      port: 587,
      user_name: Rails.application.secrets.mailgun_user,
      password: Rails.application.secrets.mailgun_password
    }

    config.middleware.use Rack::Deflater

    config.active_job.queue_adapter = :resque
  end
end
