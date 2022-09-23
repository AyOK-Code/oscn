FactoryBot.define do
  factory :case_type do
    sequence(:oscn_id)
    sequence(:name) { |n| Faker::Lorem.word + n.to_s }
    abbreviation { Faker::Name.unique.initials }

    trait :felony do
      oscn_id {31}
      name { 'CRIMINAL FELONY' }
      abbreviation { 'CF' }
    end

    trait :misdemeanor do
      name { 'CRIMINAL MISDEMEANOR' }
      abbreviation { 'CM' }
    end
  end
end
