FactoryBot.define do
  factory :oklahoma_statute do
    code { "#{rand(1..9)}.#{rand(1..9)}.#{rand(1..100)}.#{rand(1..9)}" }
    ten_digit { Faker::Number.number(digits: 10) }
    severity { ['E', 'M', 'F'].sample }
    description { Faker::Lorem.sentence }
    effective_on { Faker::Date.between(from: 10.years.ago, to: Date.current) }
  end
end
