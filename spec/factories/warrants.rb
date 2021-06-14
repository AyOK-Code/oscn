FactoryBot.define do
  factory :warrant do
    docket_events { nil }
    judges { nil }
    bond { 1 }
    comment { "MyString" }
  end
end
