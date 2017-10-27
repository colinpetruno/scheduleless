module DateAndTime
  class Parser
    def initialize(date:)
      @date = date
    end

    def dashboard_format(format = :short)
      if format == :short
        "#{day} #{I18n.t("date.abbr_day_names")[parsed_date.wday]}"
      else
        "#{day} #{I18n.t("date.abbr_day_names")[parsed_date.wday]}, #{month}"
      end
    end

    def day
      parsed_date.strftime("%-d")
    end

    def month
      parsed_date.strftime("%B")
    end

    def month_number
      parsed_date.strftime("%m")
    end

    def month_and_day
      parsed_date.strftime("%B %-d")
    end

    def self.number(date)
      date.strftime('%Y%m%d').to_i
    end

    private

    def parsed_date
      Date.parse(@date.to_s)
    end
  end
end
