module DateAndTime
  class Navigator
    def initialize(current_date: nil)
      @current_date = current_date
    end

    def date_of_next(day)
      if day.is_a? Integer
        date  = Date.parse(I18n.t("date.day_names")[day])
      else
        date  = Date.parse(day)
      end

      delta = date >= Date.today ? 0 : 7
      date + delta
    end

    private

    attr_reader :current_date
  end
end
