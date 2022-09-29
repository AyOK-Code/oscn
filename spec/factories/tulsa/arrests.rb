FactoryBot.define do
  factory :arrest do
    inmate { nil }

    arrest_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    arrested_by { Faker::Lorem.word }
    arresting_agency { Faker::Lorem.word }
    booking_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    release_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
