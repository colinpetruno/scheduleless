class StripeCreditCardMock
  include ActiveModel::Model

  attr_accessor :card_name, :card_number, :exp_month, :exp_year, :cvc,
    :name, :postal_code

  def self.month_select_options
    (1..12).to_a.map{ |i| [I18n.t("date.month_names")[i], i] }
  end

  def self.year_select_options
    (Date.today.year..Date.today.year + 20).to_a
  end
end
