class StripeCreditCardMock
  include ActiveModel::Model

  attr_accessor :card_name, :card_number, :exp_month, :exp_year, :cvc,
    :name, :postal_code
end
