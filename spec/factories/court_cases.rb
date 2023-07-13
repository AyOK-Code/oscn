FactoryBot.define do
  factory :court_case do
    sequence(:oscn_id)
    county
    case_type
    case_number { "CF-2020-#{Faker::Number.between(from: 1, to: 1000)}" }
    filed_on { Faker::Date.between(from: 2.years.ago, to: Date.current) }

    trait :invalid do
      case_number { 'CF-2020-0' }
    end

    trait :with_html do
      after(:create) { |court_case| create(:case_html, court_case:) }
    end

    trait :with_docket_event do
      after(:create) { |court_case| create(:docket_event, court_case:) }
    end

    trait :active do
      closed_on { nil }
    end

    trait :inactive do
      closed_on { Faker::Date.between(from: 2.years.ago, to: Date.current) }
    end

    trait :felony do
      case_type { CaseType.find_by(abbreviation: 'CF') || create(:case_type, :felony) }
    end

    trait :misdemeanor do
      case_type { CaseType.find_by(abbreviation: 'CM') || create(:case_type, :misdemeanor) }
    end
  end
end
