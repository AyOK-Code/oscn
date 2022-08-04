FactoryBot.define do
  factory :doc_profile, class: 'Doc::Profile' do
    doc_number { 1 }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.middle_name }
    suffix { Faker::Name.suffix }
    last_move_date { '2022-01-24' }
    facility { 'MyString' }
    birth_date { '2022-01-24' }
    sex { [:female, :male].sample }
    race { 'MyString' }
    hair { 'MyString' }
    height_ft { 'MyString' }
    height_in { 'MyString' }
    weight { 'MyString' }
    eye { 'MyString' }
    status { [:active, :inactive].sample }
  end
end
