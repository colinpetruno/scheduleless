module MobileApi
  class OfferPresenter
    def self.for(offer)
      new(offer: offer)
    end

    def initialize(offer: offer)
      @offer = offer
    end

    def as_json(_options={})
      {
        id: offer.id,
        location_city_state_zip: address.city_state_zip,
        location_name: location.name,
        location_line_1: location.line_1,
        location_line_2: location.line_2,
        location_postalcode: location.postalcode,
        note: offer.note,
        offered_by_name: offered_by_name,
        shift_end_time: shift_end_time,
        shift_date: shift_date.day,
        shift_label: shift_label,
        shift_short_month: shift_date.strftime("%b"),
        shift_start_time: shift_start_time
      }
    end

    private

    attr_reader :offer

    def address
      @_address ||= AddressFormatter.for(location)
    end

    def location
      shift.location
    end

    def offered_by_name
      "#{offer.user.given_name} #{offer.user.family_name}"
    end

    def shift
      offer.offered_shift
    end

    def shift_date
      Date.parse(shift.date.to_s)
    end

    def shift_end_time
      MinutesToTime.for(shift.minute_end)
    end

    def shift_label
      "#{shift_start_time} - #{shift_end_time}"
    end

    def shift_start_time
      MinutesToTime.for(shift.minute_start)
    end
  end
end
