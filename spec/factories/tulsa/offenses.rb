FactoryBot.define do
  factory :offense do
    arrest { nil }
    description { Faker::Lorem.word }
    case_number { Faker::Lorem.word }
    court_date { Faker::Date.in_date_period }
    bond_type { Faker::Lorem.word }
    bound_amount { Faker::Lorem.word }
    disposition { Faker::Lorem.word }
  end
end
