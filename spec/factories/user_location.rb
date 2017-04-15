FactoryGirl.define do
  factory :user_location do
    user
    location

    home false
    admin false
  end
end
