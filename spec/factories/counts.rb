FactoryBot.define do
  factory :count do
    association :case
    party
    offense_on { '2021-05-24' }
    as_filed { 'MyString' }
    filed_statute_violation { 'MyString' }
    disposition { 'MyString' }
    disposition_on { '2021-05-24' }
    disposed_statute_violation { 'MyString' }
    plea { nil }
    verdict { nil }
  end
end
