FactoryBot.define do
  factory :party do
    sequence(:oscn_id)
    full_name { Faker::Name.name }
    party_type
  end
end
