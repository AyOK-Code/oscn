FactoryBot.define do
  factory :osco_warrant do
    first_name { 'MyString' }
    last_name { 'MyString' }
    middle_name { 'MyString' }
    birth_date { '2022-10-20' }
    case_number { 'MyString' }
    bound_amount { '9.99' }
    issued { '2022-10-20' }
    counts { 'MyString' }
  end
end
