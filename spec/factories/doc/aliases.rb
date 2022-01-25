FactoryBot.define do
  factory :doc_alias, class: 'Doc::Alias' do
    doc_profile { nil }
    doc_number { 1 }
    last_name { "MyString" }
    first_name { "MyString" }
    middle_name { "MyString" }
    suffix { "MyString" }
  end
end
