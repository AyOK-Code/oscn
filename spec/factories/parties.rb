FactoryBot.define do
  factory :party do
    sequence(:oscn_id)
    full_name { Faker::Name.name }
    party_type

    trait :defendant do
      party_type { PartyType.find_by(name: 'defendant') || create(:party_type, name: 'defendant') }
    end

    trait :plantiff do
      party_type { create(:party_type, :plantiff) }
    end
  end
end
