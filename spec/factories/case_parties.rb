FactoryBot.define do
  factory :case_party do
    association :case
    party
  end
end
