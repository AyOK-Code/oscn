FactoryBot.define do
  factory :party_type do
    name { Faker::Lorem.unique.word }

    trait :defendant do
      name { 'defendant' }
    end

    trait :plaintiff do
      name { 'plaintiff' }
    end
  end
end
