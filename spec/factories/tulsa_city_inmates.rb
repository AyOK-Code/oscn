FactoryBot.define do
  factory :tulsa_city_inmate do
    inmateId { 'MyString' }
    firstName { Faker::Name.first_name }
    middleName { 'MyString' }
    lastName { Faker::Name.last_name }
    DOB { 'MyString' }
    height { 'MyString' }
    weight { 'MyString' }
    hairColor { 'MyString' }
    eyeColor { 'MyString' }
    race { 'MyString' }
    gender { 'MyString' }
    arrestDate { 'MyString' }
    arrestingOfficer { Faker::Name.name }
    arrestingAgency { 'MyString' }
    bookingDateTime { 'MyString' }
    courtDate { 'MyString' }
    releasedDateTime { 'MyString' }
    courtDivision { 'MyString' }
  end
end
