FactoryBot.define do
  factory :ok_sos_name_type, class: 'OkSos::NameType' do
    name_type_id { Faker::Number.number(digits: 10) }
    name_description { ['Trade', 'Legal'].sample }
  end
end
