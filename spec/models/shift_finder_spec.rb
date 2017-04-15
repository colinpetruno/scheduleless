require "rails_helper"

RSpec.describe ShiftFinder, type: :model do
  describe "#next" do
    it "returns the next shift" do
      user = create(:user)
      location = create(:location, company: user.company)
      user_location = create(:user_location, user: user, location: location)

      create(:shift,
             user_location: user_location,
             date: DateTime.now + 2.day, minute_start: 0, minute_end: 400)

      shift = create(:shift,
             user_location: user_location,
             date: DateTime.now + 1.day, minute_start: 0, minute_end: 200)

      create(:shift,
             user_location: user_location,
             date: DateTime.now + 1.day, minute_start: 300, minute_end: 400)

      sf = ShiftFinder.for(user)
      expect(sf.next.id).to eql(shift.id)
    end
  end
end
