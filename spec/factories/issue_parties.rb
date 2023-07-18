FactoryBot.define do
  factory :issue_party do
    issue
    party
    disposition_on { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    verdict
    verdict_details { Faker::Lorem.sentence }
  end
end
