FactoryBot.define do
  factory :party do
    sequence(:oscn_id)
    full_name { Faker::Name.name }
    party_type

    trait :with_html do
      after(:create) { |party| create(:party_html, party: party) }
    end

    trait :defendant do
      party_type { PartyType.find_by(name: 'defendant') || create(:party_type, name: 'defendant') }
    end

    trait :arresting_agency do
      party_type { PartyType.find_by(name: 'arresting_agency') || create(:party_type, name: 'arresting_agency') }
    end

    trait :plaintiff do
      party_type { create(:party_type, :plaintiff) }
    end

    trait :with_case do
      after(:create) do |party|
        court = create(:court_case)
        create(:case_party, court_case: court, party: party)
      end
    end

    trait :with_felony_case do
      after(:create) do |party|
        court = create(:court_case, :felony)
        create(:case_party, court_case: court, party: party)
      end
    end

    trait :with_misdemeanor_case do
      after(:create) do |party|
        court = create(:court_case, :misdemeanor)
        create(:case_party, court_case: court, party: party)
      end
    end
  end
end
