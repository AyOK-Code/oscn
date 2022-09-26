FactoryBot.define do
  factory :arrest do
    inmate { nil }
    arrest_date { Faker::Date.in_date_period }
    arrest_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    arrested_by { Faker::Lorem.word }
    booking_date { Faker::Date.in_date_period }
    booking_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    release_date { Faker::Date.in_date_period }
    release_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
