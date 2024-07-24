FactoryBot.define do
  factory :ok_sos_name, class: 'OkSos::Name' do
    name_id { Faker::Number.number(digits: 10) }
  end
end
