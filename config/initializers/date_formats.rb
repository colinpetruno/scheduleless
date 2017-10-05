Date::DATE_FORMATS[:month_day_year] = "%b %e, %Y"
Date::DATE_FORMATS[:month_day] = "%b %-d"
Date::DATE_FORMATS[:short_month_day] = "%-m/%-d"

# "Wed Jun 28 2017"
Date::DATE_FORMATS[:datepicker] = "%a %b %e %Y"

# Friday, June 3rd
Date::DATE_FORMATS[:full_day_and_month] = lambda do |date|
  date.strftime("%a, %b #{date.day.ordinalize}")
end
Date::DATE_FORMATS[:integer] = "%Y%m%d"

Time::DATE_FORMATS[:month_day_year] = "%b %e, %Y"
Time::DATE_FORMATS[:day_integer] = "%Y%m%d"
