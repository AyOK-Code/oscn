FactoryBot.define do
  factory :judge do
    name { Faker::Name.name }
    sequence(:oscn_id)
  end
end
