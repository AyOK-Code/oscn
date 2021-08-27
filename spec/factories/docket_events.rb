FactoryBot.define do
  factory :docket_event do
    court_case
    sequence(:row_index) { |n| n }
    event_on { Faker::Time.between(from: DateTime.now - 100, to: DateTime.now) }
    docket_event_type
    description { Faker::Lorem.paragraph }

    # TODO: Trait for any docket event type that has unique data extraction
  end
end
