FactoryBot.define do
  factory :ok_sos_entity_address, class: 'OkSos::EntityAddress' do
    address_id { Faker::Number.number(digits: 10) }
    zip_code
  end
end
