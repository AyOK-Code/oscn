FactoryBot.define do
  factory :docket_event_type do
    code { Faker::Name.unique.initials(number: rand(2..8)) }
  end
end
