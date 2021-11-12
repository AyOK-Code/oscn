FactoryBot.define do
  factory :county do
    name { Faker::Lorem.unique.word }
    fips_code { Faker::Number.number(digits: 3).to_s }
  end
end
