FactoryBot.define do
  factory :party_address do
    party
    record_on { Faker::Time.between(from: DateTime.now - 100, to: DateTime.now) }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip_code(state_abbreviation: 'OK') }
    address_type { 'Home' }
    status { 'Active' }
  end
end
