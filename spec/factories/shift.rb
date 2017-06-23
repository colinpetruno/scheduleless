FactoryGirl.define do
  factory :shift do
    company
    location
    user

    minute_start 0
    minute_end 225
    date 20180432
  end
end
