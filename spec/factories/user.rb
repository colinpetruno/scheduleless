FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "employee#{n}@example.com"
    end
    password "asdf1234"
    given_name "John"
    family_name "Doe"
    company_admin false

    company
    primary_position_id 1
  end

  factory :company_admin, class: User do
    email "user@example.com"
    password "asdf1234"
    given_name "Admin"
    family_name "User"
    company_admin true

    company
  end
end
