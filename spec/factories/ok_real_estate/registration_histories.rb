FactoryBot.define do
  factory :ok_real_estate_registration_history, class: 'OkRealEstate::RegistrationHistory' do
    external_id { 1 }
    agent { nil }
    license_category { 'MyString' }
    status { 'MyString' }
    effective_on { '2023-12-29' }
  end
end
