FactoryBot.define do
  factory :zip_code do
    name { Faker::Number.number(digits: 5) }
  end
end
