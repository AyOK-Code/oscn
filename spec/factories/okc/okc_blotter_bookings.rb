FactoryBot.define do
  factory :okc_blotter_booking do
    pdf_id { 1 }
    first_name { 'MyString' }
    last_name { 'MyString' }
    dob { '2022-08-26' }
    sex { 'MyString' }
    race { 'MyString' }
    zip { 'MyString' }
    transient { 'MyString' }
    inmate_number { 1 }
    booking_number { 1 }
    booking_type { 'MyString' }
    booking_date { '2022-08-26' }
    release_date { '2022-08-26' }
    booking_id { 1 }
    type { '' }
    bond { 'MyString' }
    code { 'MyString' }
  end
end
