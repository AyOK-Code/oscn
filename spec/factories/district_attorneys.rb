FactoryBot.define do
  factory :district_attorney do
    name { Faker::Name.name }
    sequence(:number)
  end
end
