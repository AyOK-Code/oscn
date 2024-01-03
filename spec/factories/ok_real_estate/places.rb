FactoryBot.define do
  factory :ok_real_estate_place, class: 'OkRealEstate::Place' do
    external_id { Faker::Number.unique.number(digits: 8) }
    association :agent, factory: :ok_real_estate_agent
    name { Faker::Company.name }
    branch_office { 'True' }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
