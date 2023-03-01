FactoryBot.define do
  factory :issue_party do
    issue { nil }
    party { nil }
    disposition_on { '2023-02-28' }
    verdict { nil }
    verdict_details { 'MyString' }
  end
end
