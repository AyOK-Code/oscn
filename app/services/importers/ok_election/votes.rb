module Importers
  module OkElection
    class Votes
      attr_reader :file, :data, :votes, :voting_methods

      def initialize
        @bucket = Bucket.new
        @file = @bucket.get_object('ok_election/voter_history.csv')
        @data = file.body.read
        @votes = CSV.parse(data, headers: true)
        @voting_methods = OkElectionBoard::VotingMethod.pluck(:code, :id).to_h
      end

      def self.perform
        new.perform
      end

      def perform
        bar = ProgressBar.new(votes.count)

        votes_data = []

        votes.each do |vote|
          voter_id = OkElectionBoard::Voter.find_by(voter_id: vote['VoterID'].to_i).id
          voting_method_id = voting_methods[vote['VotingMethod']]

          next if voter_id.nil? || voting_method_id.nil?

          votes_data << { voter_id: voter_id,
                          election_date: parse_date(vote['ElectionDate']),
                          voting_method_id: voting_method_id }
          bar.increment!
        end

        votes.each_slice(10_000) do |slice|
          OkElectionBoard::Vote.upsert_all(slice, unique_by: [:voter_id, :election_date])
        end
      end

      private

      def parse_date(date)
        return nil if date.blank?

        Date.strptime(date, '%m/%d/%Y')
      end
    end
  end
end
