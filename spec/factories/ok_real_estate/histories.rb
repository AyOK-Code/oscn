FactoryBot.define do
  factory :ok_real_estate_history, class: 'OkRealEstate::History' do
    agent
    license_type { ['Sales Associate', 'Broker Proprietor'].sample }
    license_status { ['Active', 'Inactive'].sample }
    license_effective_on { Faker::Date.between(from: 5.years.ago, to: 1.years.ago) }
  end
end
