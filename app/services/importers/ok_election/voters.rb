module Importers
  module OkElection
    class Voters
      attr_reader :file, :data, :voters, :precincts, :zip_codes

      def initialize
        @bucket = Bucket.new
        @file = @bucket.get_object('ok_election/voters.csv')
        @data = file.body.read
        @voters = CSV.parse(data, headers: true)
        @precincts = OkElection::Precinct.pluck(:code, :id).to_h
        @zip_codes = ZipCode.pluck(:number, :id).to_h
      end

      def self.perform
        new.perform
      end

      def perform
        bar = ProgressBar.new(voters.count)

        # Upsert the voter data 10,000 rows at a time
        voter_data = []
        voters.each do |voter|
          bar.increment!
          voter_data << voter_data(voter)

          OkElection::Voter.upsert_all(voter_data)
        end

        voters.each_slice(10_000) do |slice|
          OkElection::Voter.upsert_all(slice, unique_by: :voter_id)
        end
      end

      private

      def parse_date(date)
        return nil if date.blank?

        Date.strptime(date, '%m/%d/%Y')
      end

      def voter_data(voter)
        precinct_id = precincts[voter[0].to_i]
        zip_code_id = zip_codes[voter['Zip'].to_i]
        registration_date = parse_date(voter['OriginalRegistration'])
        date_of_birth = parse_date(voter['DateOfBirth'])

        {
          voter_id: voter['VoterID'],
          precinct_id: precinct_id,
          last_name: voter['LastName'],
          first_name: voter['FirstName'],
          middle_name: voter['MiddleName'],
          suffix: voter['Suffix'],
          political_affiliation: OkElection::Voter.political_affiliations[voter['PolitalAff']],
          status: voter['Status'] == 'A' ? OkElection::Voter.statuses['active'] : OkElection::Voter.statuses['inactive'],
          street_number: voter['StreetNum'],
          street_direction: voter['StreetDir'],
          street_name: voter['StreetName'],
          street_type: voter['StreetType'],
          building_number: voter['BldgNum'],
          city: voter['City'],
          zip_code_id: zip_code_id,
          date_of_birth: date_of_birth,
          original_registration: registration_date
        }
      end
    end
  end
end
