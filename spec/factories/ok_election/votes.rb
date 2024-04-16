FactoryBot.define do
  factory :ok_election_vote, class: 'OkElection::Vote' do
    voter
    election_on { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    voting_method
  end
end
