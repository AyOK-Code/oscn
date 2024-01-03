module Importers
  module OkRealEstate
    class Agent
      attr_reader :take, :skip

      def initialize(take, skip)
        @take = take
        @skip = skip
      end

      def self.perform(take, skip)
        new(take, skip).perform
      end

      def perform
        url = build_url(take, skip)
        data = HTTParty.get(url)
        data['result'].each do |agent_json|
          a = find_or_initialize_agent(agent_json)
          a.assign_attributes(
            first_name: agent_json['firstName'],
            middle_name: agent_json['middleName'],
            last_name: agent_json['lastName'],
            other_name: agent_json['otherName'],
            license_number: agent_json['licenseNumber'],
            license_category: agent_json['licenseCategory'],
            license_status: agent_json['licenseStatus'],
            initial_license_on: agent_json['initialLicenseDate'],
            license_expiration_on: agent_json['licenseExpirationDate'],
            has_public_notices: agent_json['hasPublicNotices']
          )
          a.save
        end
      end

      def fetch_count
        url = build_url(take, skip)
        data = HTTParty.get(url)
        data['resultCount']
      end

      private

      def build_url(take, skip)
        "https://orec.us.thentiacloud.net/rest/public/registrant/search/?keyword=all&skip=#{skip}&take=#{take}&statusQuery=(*)"
      end

      def find_or_initialize_agent(agent_json)
        ::OkRealEstate::Agent.find_or_initialize_by(
          external_id: agent_json['id']
        )
      end
    end
  end
end
