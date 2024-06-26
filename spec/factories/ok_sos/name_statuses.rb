FactoryBot.define do
  factory :ok_sos_name_status, class: 'OkSos::NameStatus' do
    name_status_id { Faker::Number.number(digits: 10) }
  end
end
