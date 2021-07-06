FactoryBot.define do
  factory :warrant do
    docket_event
    judge
    bond { Faker::Number.number(digits: rand(3..5)) }
    comment { Faker::Lorem.paragraph }
  end
end
