FactoryBot.define do
  factory :parcel do
    geoid20 { Faker::String.random(length: 4)}
    zip { Faker::Address.zip_code }
    tract { Faker::Lorem.word  }
    block { Faker::Lorem.word }
    lat { Faker::Address.latitude }
    long { Faker::Address.longitude }
  end
end
