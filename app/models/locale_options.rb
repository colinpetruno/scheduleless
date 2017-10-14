class LocaleOptions
  def self.for_select
    [
      [I18n.t("models.locale_options.en"), "en"],
      [I18n.t("models.locale_options.de"), "de"]
    ]
  end

  def self.valid_locales
    %w(en de)
  end
end
