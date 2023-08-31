FactoryBot.define do
  factory :tulsa_city_inmate, class: TulsaCity::Inmate do
    inmate_id { 'MyString' }
    first_name { Faker::Name.first_name }
    middle_name { 'MyString' }
    last_name { Faker::Name.last_name }
    dob { 'MyString' }
    height { 'MyString' }
    weight { 'MyString' }
    hair_color { 'MyString' }
    eye_color { 'MyString' }
    race { 'MyString' }
    gender { 'MyString' }
    arrest_date { 'MyString' }
    arresting_officer { Faker::Name.name }
    arresting_agency { 'MyString' }
    booking_date_time { 'MyString' }
    court_date { 'MyString' }
    released_date_time { 'MyString' }
    court_division { 'MyString' }
  end
end
