FactoryBot.define do
  factory :inmate do
    first { Faker::Lorem.word }
    middle { Faker::Lorem.word }
    last { Faker::Lorem.word }
    gender { Faker::Lorem.word }
    roster { '' }
    booking { '' }
    race { Faker::Lorem.word }
    address { Faker::Lorem.word }
    height { Faker::Lorem.word }
    weight { '' }
    zip { '' }
    hair { Faker::Lorem.word }
    eyes { Faker::Lorem.word }
  end
end
