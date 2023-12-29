require 'progress_bar'
require 'csv'

namespace :migrate do
  desc 'Pull in Voting Methods'
  task voting_methods: :environment do
    OkElection::VotingMethods.perform
  end

  desc 'Pull in Voter History'
  task votes: :environment do
    OkElection::Votes.perform
  end

  desc 'Pull in Precincts'
  task precincts: :environment do
    OkElection::Precincts.perform
  end

  desc 'Pull in Voters'
  task voters: :environment do
    OkElection::Voters.perform
  end
end
