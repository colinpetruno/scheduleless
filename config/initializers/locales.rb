require "i18n/backend/fallbacks"

I18n.config.available_locales = [:en, :de]
I18n.default_locale = :en

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
