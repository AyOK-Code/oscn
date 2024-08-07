FactoryBot.define do
  factory :case_type do
    sequence(:oscn_id)
    sequence(:name) { |n| Faker::Lorem.word + n.to_s }
    abbreviation { Faker::Name.unique.initials }

    trait :felony do
      name { 'CRIMINAL FELONY' }
      abbreviation { 'CF' }
    end

    trait :misdemeanor do
      name { 'CRIMINAL MISDEMEANOR' }
      abbreviation { 'CM' }
    end

    trait :small_claim do
      name { 'SMALL CLAIMS' }
      abbreviation { 'SC' }
    end
  end
end
