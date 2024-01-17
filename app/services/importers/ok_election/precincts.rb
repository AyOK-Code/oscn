module Importers
  module OkElection
    class Precincts
      attr_accessor :precincts, :counties

      def initialize
        @bucket = Bucket.new
        @file = @bucket.get_object('ok_election/precincts.csv')
        @data = @file.body.read
        @precincts = CSV.parse(@data, headers: true)
        @counties = County.all.pluck(:ok_code, :id).to_h
      end

      def self.perform
        new.perform
      end

      def perform
        bar = ProgressBar.new(precincts.count)
        @precincts.each do |precinct|
          p = ::OkElection::Precinct.find_or_initialize_by(code: precinct["PrecinctCode"])
          p.update(precinct_attributes(precinct))
          bar.increment!
        end
      end

      private

      def precinct_attributes(precinct)
        {
          county_id: counties[precinct["PrecinctCode"][0..1].to_i],
          congressional_district: precinct["CongressionalDistrict"],
          state_senate_district: precinct["StateSenateDistrict"],
          state_house_district: precinct["StateHouseDistrict"],
          county_commissioner: precinct["CountyCommissioner"],
          poll_site: precinct["PollSite"],
          poll_site_address: precinct["PollSiteAddress"],
          poll_site_address2: precinct["PollSiteAddress2"],
          poll_site_city: precinct["PollSiteCity"],
          poll_site_zip: precinct["PollSiteZip"]
        }
      end
    end
  end
end
