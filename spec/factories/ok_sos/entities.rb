FactoryBot.define do
  factory :ok_sos_entity, class: 'OkSos::Entity' do
    filing_number { Faker::Number.number(digits: 10) }
    external_corp_type_id { Faker::Number.number(digits: 10) }
    corp_type factory: :ok_sos_corp_type
  end
end
