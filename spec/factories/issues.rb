FactoryBot.define do
  factory :issue do
    number { Faker::Number.between(from: 1, to: 10) }
    name { Faker::Lorem.word }
    count_code
    filed_by { Faker::Lorem.word }
    filed_on { Faker::Date.between(from: 2.months.ago, to: Date.current) }
  end
end
