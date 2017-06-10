module MobileApi
  class TradePresenter
    def self.for(trade)
      new(trade: trade)
    end

    def initialize(trade:)
      @trade = trade
    end

    def as_json(_options={})
      {
        id: trade.id,
        location_city_state_zip: address.city_state_zip,
        location_name: location.name,
        location_line_1: location.line_1,
        location_line_2: location.line_2,
        location_postalcode: location.postalcode,
        note: trade.note,
        offered_by_name: offered_by_name,
        shift_end_time: shift_end_time,
        shift_date: shift_date.day,
        shift_label: shift_label,
        shift_short_month: shift_date.strftime("%b"),
        shift_start_time: shift_start_time
      }
    end

    private

    attr_reader :trade

    def address
      @_address ||= AddressFormatter.for(location)
    end

    def offered_by_name
      "#{trade.user.given_name} #{trade.user.family_name}"
    end

    def shift
      trade.shift
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

    def location
      trade.location
    end
  end
end
