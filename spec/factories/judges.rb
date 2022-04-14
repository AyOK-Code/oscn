FactoryBot.define do
  factory :judge do
    name { Faker::Name.full_name }
    sequence(:oscn_id)
  end
end
