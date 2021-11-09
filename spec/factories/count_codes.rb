FactoryBot.define do
  factory :count_code do
    code { Faker::Name.unique.initials }
    description { Faker::Lorem.sentence }
  end
end
