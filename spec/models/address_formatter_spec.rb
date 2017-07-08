require "rails_helper"

RSpec.describe UserFinder do

  def location
    Location.new(
        line_1: "blue",
        line_3: "blu",
        county_province: "Ma",
        postalcode: "02130",
        city: "Boston")
  end

  describe "#address" do
    it "should get rid of nils" do
      formatter = AddressFormatter.for(location)

      expect(formatter.address).to eql(["blue", "blu"])
    end
  end

  describe "city_state_zip" do
    it "should concatenate the city, province and postal code" do
      formatter = AddressFormatter.for(location)

      expect(formatter.city_state_zip).to eql("Boston Ma 02130")
    end
  end
end
