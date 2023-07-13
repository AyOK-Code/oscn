FactoryBot.define do
  factory 'Ocso::Warrant' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { Faker::Name.initials(number: 1) }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    case_number { 'CF94008641' }
    bond_amount { '9.99' }
    issued { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    counts { '(1) 211713001B CF CONCEALING STOLEN PROPERTY :' }
  end
end
