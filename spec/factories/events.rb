FactoryBot.define do
  factory :event do
    court_case
    party
    event_ { '2021-05-26' }
    event_type { 'MyString' }
    docket { 'MyString' }
  end
end
