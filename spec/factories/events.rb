FactoryBot.define do
  factory :event do
    court_case
    event_at { Faker::Date.between(from: 10.days.ago, to: Date.current) }
    event_type { Faker::Lorem.sentence }
    docket { "Docket #{Faker::Lorem.characters(number: 1).upcase}" }
  end
end
