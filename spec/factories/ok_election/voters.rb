FactoryBot.define do
  factory :ok_election_voter, class: 'OkElection::Voter' do
    precinct
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    voter_id { Faker::Number.number(digits: 10) }
    political_affiliation { ['REP', 'DEM', 'IND', 'LIB'].sample }
    status { ['inactive', 'active'].sample }
  end
end
