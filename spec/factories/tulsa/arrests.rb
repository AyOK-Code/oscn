FactoryBot.define do
  factory :arrest do
    inmate { nil }
    arrest_date { Faker::Lorem.word }
    arrest_time { Faker::Lorem.word }
    arrested_by { Faker::Lorem.word }
    booking_date { Faker::Lorem.word }
    booking_time { Faker::Lorem.word }
    release_date { Faker::Lorem.word }
    release_time { Faker::Lorem.word }
  end
end
