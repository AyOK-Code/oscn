FactoryBot.define do
  factory :ok_election_precinct, class: 'OkElection::Precinct' do
    county
    code { Faker::Number.number(digits: 4) }
    congressional_district { Faker::Number.number(digits: 2) }
    state_senate_district { Faker::Number.number(digits: 2) }
    state_house_district { Faker::Number.number(digits: 2) }
    county_commisioner { Faker::Number.number(digits: 2) }
  end
end
