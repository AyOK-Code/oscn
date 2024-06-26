FactoryBot.define do
  factory :ok_sos_officer, class: 'OkSos::Officer' do
    officer_id { Faker::Number.number(digits: 10) }
  end
end
