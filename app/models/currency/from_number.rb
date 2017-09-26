module Currency
  class FromNumber
    include ActionView::Helpers::NumberHelper

    def self.for(number)
      new(number_in_cents: number).convert
    end

    def initialize(number_in_cents:, currency: "USD")
      @currency = currency
      @number_in_cents = number_in_cents
    end

    def convert
      dollars = number_in_cents.to_f / 100.to_f

      number_to_currency(dollars)
    end

    private

    attr_reader :currency, :number_in_cents
  end
end
