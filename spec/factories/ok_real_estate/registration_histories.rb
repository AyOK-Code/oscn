FactoryBot.define do
  factory :ok_real_estate_registration_history, class: 'OkRealEstate::RegistrationHistory' do
    external_id { Faker::Number.unique.number(digits: 8) }
    association :agent, factory: :ok_real_estate_agent
    license_category { 'MyString' }
    status { 'MyString' }
    effective_on { '2023-12-29' }
  end
end
