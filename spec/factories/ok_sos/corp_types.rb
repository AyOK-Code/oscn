FactoryBot.define do
  factory :ok_sos_corp_type, class: 'OkSos::CorpType' do
    corp_type_id { Faker::Number.number(digits: 9) }
    corp_type_description { Faker::Company.industry }
  end
end
