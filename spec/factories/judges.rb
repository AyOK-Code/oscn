FactoryBot.define do
  factory :judge do
    name { 'MyString' }
    courthouse { 'MyString' }
    judge_type { 'MyString' }
    county { nil }
  end
end
