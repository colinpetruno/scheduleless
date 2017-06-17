source "https://rubygems.org"

gem "rails", "~> 5.0.1"
gem "bcrypt", "~> 3.1.7"
gem "bootstrap", "~> 4.0.0.alpha6"
gem "bourbon"
gem "bugsnag"
gem "chewy"
gem "country_select"
gem "devise"
gem "devise_invitable"
gem "doorkeeper"
gem "fcm"
gem "jquery-rails"
gem "holidays"
gem "pg"
gem "puma", "~> 3.0"
gem "pundit"
gem "reamaze"
gem "resque"
gem "resque-pool"
gem "resque-web", require: "resque_web"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "stripe"
gem "turbolinks", "~> 5"
gem "twilio-ruby"
gem "uglifier", ">= 1.3.0"

source "https://rails-assets.org" do
  gem "rails-assets-tether"
  gem "rails-assets-typeahead.js"
end

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "rspec-rails", "~> 3.5"
end

group :development do
  gem "web-console", ">= 3.3.0"
end

ruby "2.3.1"
