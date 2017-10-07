require "rails_helper"

RSpec.describe Shifts::Finder, type: :model do
  describe "#next" do
    it "returns the next shift" do
      user = create(:user)
      location = create(:location, company: user.company)

      create(:shift,
             location: location,
             user: user,
             date: (Date.today + 2.day).to_s(:integer),
             minute_start: 0,
             minute_end: 400)

      shift = create(:shift,
             location: location,
             user: user,
             date: (Date.today + 1.day).to_s(:integer),
             minute_start: 0,
             minute_end: 200)

      create(:shift,
             location: location,
             user: user,
             date: (Date.today + 1.day).to_s(:integer),
             minute_start: 300,
             minute_end: 400)

      sf = Shifts::Finder.for(user)
      expect(sf.next.find.id).to eql(shift.id)
    end
  end
end
