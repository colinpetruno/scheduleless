module MobileApi
  class OffersPresenter
    def self.for(offers)
      new(offers: offers)
    end

    def initialize(offers:)
      @offers = offers
    end

    def as_json(_options={})
      offers.map do |offer|
        OfferPresenter.for(offer).as_json
      end
    end

    private

    attr_reader :offers
  end
end
