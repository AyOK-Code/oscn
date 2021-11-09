FactoryBot.define do
  factory :count do
    court_case
    party
    offense_on { Faker::Time.between(from: DateTime.now - 100, to: DateTime.now) }
    as_filed { Faker::Lorem.sentence }
    filed_statute_violation { "#{Faker::Number.number(digits: 2)} O.S. #{Faker::Number.number(digits: 3)}" }
    association :filed_statute_code, factory: :count_code
    plea
    verdict
  end
end
