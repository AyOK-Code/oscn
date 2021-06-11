FactoryBot.define do
  factory :event do
    court_case
    event_at { '2021-05-26' }
    event_type { 'MyString' }
    docket { 'MyString' }
  end
end
