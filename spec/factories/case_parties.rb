FactoryBot.define do
  factory :case_party do
    association :court_case
    party
  end
end
