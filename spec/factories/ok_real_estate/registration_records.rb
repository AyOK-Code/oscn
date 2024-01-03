FactoryBot.define do
  factory :ok_real_estate_registration_record, class: 'OkRealEstate::RegistrationRecord' do
    external_id { 1 }
    agent { nil }
    license_number { 1 }
    license_category { "MyString" }
    status { "MyString" }
    effective_on { "2023-12-29" }
    initial_registration_on { "2023-12-29" }
    expiry_date { "2023-12-29" }
  end
end
