module OkElection
  class Precincts
    attr_accessor :precincts

    def initialize
      # TODO: Replace this with a call to the S3 bucket
      @bucket = Bucket.new
      @file = @bucket.get_object('ok_election_board/precincts.csv')
      @data = file.body.read
      @precincts = CSV.parse(data, headers: true)
    end

    def self.perform
      new.perform
    end

    def perform
      bar = ProgressBar.new(precincts.count)
      @precincts.each do |precinct|
        p = OkElection::Precinct.find_or_initialize_by(code: precinct[:code])
        p.update(precinct_attributes(precinct))
        bar.increment!
      end
    end

    private

    def precinct_attributes(precinct)
      # TODO: Adjust to reference actual CSV headers
      {
        county_id: County.find_by(name: precinct[:county]).id,
        code: precinct[:code],
        congressional_district: precinct[:congressional_district],
        state_senate_district: precinct[:state_senate_district],
        state_house_district: precinct[:state_house_district],
        county_commissioner: precinct[:county_commissioner],
        poll_site: precinct[:poll_site]
      }
    end
  end
end
