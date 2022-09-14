FactoryBot.define do
  factory :roster do
    birth_year { Faker::Lorem.word }
    birth_month { Faker::Lorem.word }
    birth_day { Faker::Lorem.word }
    sex { Faker::Lorem.word }
    race { Faker::Lorem.word }
    street_address { Faker::Lorem.word }
    zip { 1 }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    middle_name { Faker::Name.name }
  end
end
