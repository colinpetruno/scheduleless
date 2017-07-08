class AddressFormatter
  include ActionView::Helpers::OutputSafetyHelper

  def self.for(location)
    new(location: location)
  end

  def initialize(location:)
    @location = location
  end

  def address
    [location.line_1, location.line_2, location.line_3].reject(&:blank?)
  end

  def calendar_stream
    (address << city_state_zip).join("\r\n")
  end

  def city_state_zip
    [location.city, location.county_province, location.postalcode].join(" ")
  end

  def multiline_html
    safe_join(address.push(city_state_zip).reject(&:blank?), ("<br>".html_safe))
  end

  private

  attr_reader :location
end
