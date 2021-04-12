FactoryBot.define do
  factory :case_type do
    oscn_id { 1 }
    name { Faker::Lorem.word }
    abbreviation { Faker::Name.initials }
  end
end
