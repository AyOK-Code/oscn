FactoryBot.define do
  factory :ok_election_vote, class: 'OkElection::Vote' do
    voter { nil }
    election_on { "2023-12-10 21:42:56" }
    voting_method { nil }
  end
end
