FactoryBot.define do
  factory :ok_real_estate_place, class: 'OkRealEstate::Place' do
    agent
    name { Faker::Company.name }
    branch_office { 'True' }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
