FactoryBot.define do
  factory :case_type do
    sequence(:oscn_id)
    name { Faker::Lorem.unique.word }
    abbreviation { Faker::Name.unique.initials }

    trait :felony do
      name { 'CRIMINAL FELONY' }
      abbreviation { 'CF' }
    end

    trait :misdemeanor do
      name { 'CRIMINAL MISDEMEANOR' }
      abbreviation { 'CM' }
    end
  end
end
