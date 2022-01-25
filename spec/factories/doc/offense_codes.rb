FactoryBot.define do
  factory :doc_offense_code, class: 'Doc::OffenseCode' do
    statute_code { "MyString" }
    description { "MyString" }
    is_violent { false }
  end
end
