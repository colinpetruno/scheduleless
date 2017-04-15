FactoryGirl.define do
  factory :shift do
    company
    user_location

    minute_start 0
    minute_end 225
    date 20180432
  end
end
