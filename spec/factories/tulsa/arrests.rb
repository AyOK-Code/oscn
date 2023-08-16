FactoryBot.define do
  factory :tulsa_blotter_arrest, class: 'TulsaBlotter::Arrest' do
    booking_id { Faker::Number.number(digits: 11) }
  end
end
