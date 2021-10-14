FactoryBot.define do
  factory :party_type do
    name { Faker::Lorem.unique.word }

    trait :defendant do
      name { 'defendant' }
    end

    trait :plantiff do
      name { 'plantiff' }
    end
  end
end
