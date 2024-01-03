FactoryBot.define do
  factory :ok_real_estate_agent, class: 'OkRealEstate::Agent' do
    external_id { Faker::Number.unique.number(digits: 8) }
    license_number { Faker::Number.unique.number(digits: 8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    license_status { ['Active', 'Inactive'].sample }
    license_category { ['Sales Associate', 'Broker Proprietor'].sample }
    initial_license_on { Faker::Date.between(from: 5.years.ago, to: 1.years.ago) }
    license_expiration_on { Faker::Date.between(from: 1.years.from_now, to: 5.years.from_now) }
    has_public_notices { Faker::Boolean.boolean }
  end
end
