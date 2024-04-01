FactoryBot.define do
  factory :ok_election_voting_method, class: 'OkElection::VotingMethod' do
    code { Faker::Number.number(digits: 2) }
    name { Faker::Lorem.word }
  end
end
