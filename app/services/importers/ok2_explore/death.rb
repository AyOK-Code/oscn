module Importers
  module Ok2Explore
    class Death
      attr_reader :record

      def initialize(record)
        @record = record
      end

      def self.perform(record)
        new(record).perform
      end

      def perform
        ::Ok2Explore::Death.find_or_create_by!(
          first_name: record['firstName'],
          last_name: record['lastName'],
          middle_name: record['middleName'],
          death_on: Date.parse(record['deathDate']),
          county_id: find_county_id(record['deathCounty']),
          sex: record['gender'] == 'M' ? 'male' : 'female'
        )
      end

      def find_county_id(county_name)
        if ['LeFlore', 'RogerMills'].include?(county_name)
          name = county_name.gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
          County.find_by!(name: name).id
        else
          County.find_by(name: county_name)&.id
        end
      end
    end
  end
end
