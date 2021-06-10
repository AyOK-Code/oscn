FactoryBot.define do
  factory :court_case do
    sequence(:oscn_id)
    county
    case_type
    case_number { "CF-2020-#{Faker::Number.between(from: 1, to: 1000)}" }
    filed_on { Faker::Date.between(from: 2.years.ago, to: Date.today) }

    trait :with_html do
      html { '<div></div>' }
    end
  end
end
