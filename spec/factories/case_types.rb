FactoryBot.define do
  factory :case_type do
    sequence(:oscn_id)
    name { Faker::Lorem.word }
    abbreviation { Faker::Name.initials }
  end
end
