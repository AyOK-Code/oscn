FactoryBot.define do
  factory :ok_sos_corp_status, class: 'OkSos::CorpStatus' do
    status_id { Faker::Number.number(digits: 10) }
  end
end
