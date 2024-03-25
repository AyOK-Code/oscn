require 'progress_bar'
require 'csv'

namespace :import do
  desc 'Pull in Voting Methods'
  task voting_methods: :environment do
    Importers::OkElection::VotingMethods.perform
  end

  desc 'Pull in Voter History'
  task votes: :environment do
    Importers::OkElection::Votes.perform
  end

  desc 'Pull in Precincts'
  task precincts: :environment do
    Importers::OkElection::Precincts.perform
  end

  desc 'Pull in Voters'
  task voters: :environment do
    Importers::OkElection::Voters.perform
  end
end
