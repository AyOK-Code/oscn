FactoryBot.define do
  factory :ok_sos_filing_type, class: 'OkSos::FilingType' do
    filing_type_id { Faker::Number.number(digits: 10) }
  end
end
