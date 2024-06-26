FactoryBot.define do
  factory :ok_sos_suffix, class: 'OkSos::Suffix' do
    suffix_id { Faker::Number.number(digits: 10) }
  end
end
