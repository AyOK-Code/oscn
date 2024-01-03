module Importers
  module OkRealEstate
    class AgentDetail
      attr_reader :id, :base_url, :agent

      def initialize(id)
        @id = id
        @base_url = "https://orec.us.thentiacloud.net/rest/public/registrant/get/?id=#{id}"
        @agent = ::OkRealEstate::Agent.find_by(external_id: id)
      end

      def self.perform(id)
        new(id).perform
      end

      def perform
        response = HTTParty.get(base_url)
        data = JSON.parse(response)
        agent.update(scraped_on: DateTime.now)

        process_places(data)
        process_records(data)
        process_history(data)
      end

      private

      def find_or_create_place(place_json)
        ::OkRealEstate::Place.find_or_initialize_by(
          external_id: place_json['id']
        )
      end

      def process_places(data)
        data['placesOfPractice'].each do |place_json|
          place = find_or_create_place(place_json)
          place.assign_attributes(place_attributes(place_json))
          place.save

          agent.places << place unless agent.places.include?(place)
        end
      end

      def place_attributes(place_json)
        {
          start_date: place_json['startDate'],
          end_date: place_json['endDate'],
          primary: place_json['primary'],
          registrant: place_json['registrant'],
          phone: place_json['phone'],
          position: place_json['position'],
          email: place_json['email'],
          active: place_json['active'],
          employer_name: place_json['employerName'],
          business_address: place_json['businessAddress'],
          business_city: place_json['businessCity'],
          business_state: place_json['businessState'],
          business_zip_code: place_json['businessZipCode'],
          organization: place_json['organization'],
          is_branch_office: place_json['isBranchOffice']
        }
      end

      def process_records(data)
        data['registrationRecords'].each do |record_json|
          record = ::OkRealEstate::RegistrationRecord.find_or_initialize_by(
            agent_id: agent.id
          )
          record.assign_attributes(registration_record_attributes(record_json))
          record.save
        end
      end

      def registration_record_attributes(record_json)
        {
          external_id: record_json['id'],
          agent_id: agent.id,
          license_number: record_json['licenseNumber'],
          license_category: record_json['classOfRegistration'],
          status: record_json['registrationStatus'],
          effective_on: parse_date(record_json['effectiveDate']),
          initial_registration_on: parse_date(record_json['initialRegistrationDate']),
          expiry_date: parse_date(record_json['expiryDate'])
        }
      end

      def process_history(data)
        data['registrationHistory'].each do |history_json|
          history = ::OkRealEstate::RegistrationHistory.find_or_initialize_by(
            external_id: history_json['id']
          )
          history.assign_attributes(registration_history_attributes(history_json))
          history.save
        end
      end

      def registration_history_attributes(history_json)
        {
          external_id: history_json['id'],
          agent_id: agent.id,
          license_category: history_json['classOfRegistration'],
          status: history_json['registrationStatus'],
          effective_on: parse_date(history_json['effectiveDate'])
        }
      end

      def parse_date(date)
        return nil if date.blank?

        begin
          Date.strptime(date, '%b-%d-%Y')
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
