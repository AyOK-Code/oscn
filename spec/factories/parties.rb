FactoryBot.define do
  factory :party do
    oscn_id { Faker::Number.unique.number(10) }
    full_name { Faker::Name.name }
    party_type
  end
end
