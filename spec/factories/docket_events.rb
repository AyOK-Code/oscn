FactoryBot.define do
  factory :docket_event do
    association :case
    event_on { "2021-06-02" }
    docket_event_type
    description { "MyText" }
    amount { 1 }
  end
end
