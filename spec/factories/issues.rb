FactoryBot.define do
  factory :issue do
    number { 1 }
    name { "MyString" }
    count_code { nil }
    filed_by { nil }
    filed_on { "2023-02-28" }
  end
end
