FactoryGirl.define do
  factory :position do
    company
    name "Manager"

    trait :location_admin do
      location_admin true
    end

    trait :company_admin do
      company_admin true
    end
  end
end
