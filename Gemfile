source "https://rubygems.org"

gem 'rails', '~> 6.0.0.beta1'
gem "bcrypt", "~> 3.1.7"
gem "bootstrap", "~> 4.3.1"
gem "bourbon"
gem "bugsnag"
gem "carrierwave"
gem "chewy"
gem "country_select"
gem "devise"
gem "devise_invitable"
gem "doorkeeper"
gem "fcm"
gem "fog-aws"
gem "kaminari"
gem "icalendar"
gem "jquery-rails"
gem "holidays"
gem "newrelic_rpm"
gem "pg"
gem "puma", "~> 3.0"
gem "pundit"
gem "rack-attack"
gem "resque"
gem "resque-pool"
gem "resque-web", require: "resque_web"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem 'sitemap_generator'
gem "stripe"
# gem "trix"
gem "turbolinks", "~> 5"
gem "twilio-ruby"
gem "uglifier", ">= 1.3.0"

source "https://rails-assets.org" do
  gem "rails-assets-chartjs"
  gem "rails-assets-d3"
  gem "rails-assets-pikaday"
  gem "rails-assets-popper.js"
  gem "rails-assets-select2"
  gem "rails-assets-tether"
  gem "rails-assets-typeahead.js"
end

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "i18n-tasks"
  gem "nokogiri"
  gem "pry-rails"
  gem "pry-stack_explorer"
end

group :development do
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "rspec-rails", "~> 3.5"
end

ruby "2.6.1"
