class AddressFormatter
  def self.for(location)
    new(location: location)
  end

  def initialize(location:)
    @location = location
  end

  def address
    [location.line_1, location.line_2, location.line_3].compact
  end

  def city_state_zip
    [location.city, location.county_province, location.postalcode].join(" ")
  end

  private

  attr_reader :location
end
