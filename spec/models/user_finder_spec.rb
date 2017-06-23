require "rails_helper"

RSpec.describe UserFinder do
  describe "#admins_for_location" do
    it "should return location and company admins" do
      company = create(:company)
      position1 = create(:position, :company_admin, company: company)
      user1 = create(:user, company: company, primary_position_id: position1.id)

      position2 = create(:position, :location_admin, company: company)
      user2 = create(:user, company: company, primary_position_id: position2.id)

      position3 = create(:position, company: company)
      user3 = create(:user, company: company, primary_position_id: position3.id)

      location = create(:location, company: company)

      create(:user_location, user: user1, location: location)
      create(:user_location, user: user2, location: location)
      create(:user_location, user: user3, location: location)

      users = UserFinder.new(location: location).admins_for_location

      expect(users.length).to eql 2
    end
  end

  describe "#company_admins" do
    it "should return only company admins" do
      company = create(:company)
      position1 = create(:position, :company_admin, company: company)
      user1 = create(:user, company: company, primary_position_id: position1.id)

      position2 = create(:position, company: company)
      user2 = create(:user, company: company, primary_position_id: position2.id)

      location = create(:location, company: company)

      create(:user_location, user: user1, location: location)
      create(:user_location, user: user2, location: location)

      users = UserFinder.new(location: location).company_admins

      expect(users.length).to eql 1
      expect(users.first.id).to eql user1.id
    end
  end

  describe "#location_admins" do
    it "should return only admins for that location" do
      company = create(:company)
      position1 = create(:position, :location_admin, company: company)
      user1 = create(:user, company: company, primary_position_id: position1.id)

      position2 = create(:position, company: company)
      user2 = create(:user, company: company, primary_position_id: position2.id)

      location = create(:location, company: company)

      create(:user_location, user: user1, location: location)
      create(:user_location, user: user2, location: location)

      users = UserFinder.new(location: location).location_admins

      expect(users.length).to eql 1
      expect(users.first.id).to eql user1.id
    end
  end
end
