FactoryBot.define do
  factory :event_type do
    sequence(:oscn_id)
    code { Faker::Name.unique.initials(number: rand(2..8)) }
    name { Faker::Lorem.sentence }
  end
end
