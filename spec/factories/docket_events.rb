FactoryBot.define do
  factory :docket_event do
    court_case
    sequence(:row_index) { |n| n }
    event_on { Faker::Time.between(from: DateTime.now - 100, to: DateTime.now) }
    docket_event_type
    description { Faker::Lorem.paragraph }

    trait :return_warrant do
      docket_event_type { DocketEventType.find_by(code: 'RETWA') || create(:docket_event_type, :return_warrant) }
    end
  end
end
