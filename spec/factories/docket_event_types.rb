FactoryBot.define do
  factory :docket_event_type do
    code { Faker::Name.unique.initials(number: rand(2..8)) }

    trait :tax_intercepted do
      code { 'CTRS' }
    end

    trait :warrant_issued do
      code { DocketEventType::WARRANT_CODES.sample }
    end

    trait :return_warrant do
      code { 'RETWA' }
    end
  end
end
