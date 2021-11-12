FactoryBot.define do
  factory :plea do
    name { Faker::Lorem.unique.word }
  end
end
