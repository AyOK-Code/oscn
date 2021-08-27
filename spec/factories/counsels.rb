FactoryBot.define do
  factory :counsel do
    name { Faker::Name.name }
    address { Faker::Address.street_name }
    bar_number { Faker::Number.unique.number(digits: 6) }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.middle_name }
    last_name { Faker::Name.last_name }
  end
end
