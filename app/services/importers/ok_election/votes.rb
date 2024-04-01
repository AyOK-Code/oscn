module Importers
  module OkElection
    class Votes
      attr_reader :bucket, :voting_methods

      def initialize
        @bucket = Bucket.new
        @voting_methods = ::OkElection::VotingMethod.pluck(:code, :id).to_h
      end

      def self.perform
        Rails.logger.silence { new.perform }
      end

      def perform
        objects = bucket.list_objects('ok_election/voter_history')
        objects['contents'].each do |object|
          next unless object['key'] == 'ok_election/voter_history/CTY55_vh.csv'

          file = bucket.get_object(object['key'])
          next unless file.content_type == 'text/csv'

          votes = CSV.parse(file.body.read, headers: true)
          bar = ProgressBar.new(votes.count)
          votes_data = []

          votes.each do |vote|
            bar.increment!
            voter_id = voter_id(vote['VoterID'].to_i)
            voting_method_id = voting_methods[vote['VotingMethod']]

            next if voter_id.nil? || voting_method_id.nil?

            votes_data << voter_attributes(voter_id, vote, voting_method_id)
          end

          insert_votes(votes_data)
        end
      end

      private

      def insert_votes(votes_data)
        votes_data.each_slice(10_000) do |slice|
          ::OkElection::Vote.upsert_all(slice, unique_by: [:voter_id, :election_on])
        end
      end

      def voter_attributes(voter_id, vote, voting_method_id) 
        {
          voter_id: voter_id,
          election_on: parse_date(vote['ElectionDate']),
          voting_method_id: voting_method_id
        }
      end

      def voter_id(voter_id)
        ::OkElection::Voter.find_by(voter_id: voter_id).id
      end

      def parse_date(date)
        return nil if date.blank?

        Date.strptime(date, '%m/%d/%Y')
      end
    end
  end
end
