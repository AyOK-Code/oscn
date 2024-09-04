require 'csv'

module Importers
  module OkAssessor
    class Improvements < BaseImporter
      attr_reader :accounts

      # rubocop:disable Metrics/MethodLength
      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          building_num: row['BUILDING_NUM'],
          property_type: row['PROPERTY_TYPE'],
          neighborhood_code: row['NEIGHBORHOOD_CODE'],
          owner_occupied: row['OWNER_OCCUPIED'],
          occupancy_code: row['OCCUPANCY_CODE'],
          occupancy_description: row['OCCUPANCY_DESCRIPTION'],
          building_type: row['BUILDING_TYPE'],
          square_feet: row['SQUARE_FEET'],
          condominium_square_feet: row['CONDOMINIUM_SQUARE_FEET'],
          total_basement_square_feet: row['TOTAL_BASEMENT_SQUARE_FEET'],
          finished_basement_square_feet: row['FINISHED_BASEMENT_SQUARE_FEET'],
          garage_square_feet: row['GARAGE_SQUARE_FEET'],
          carport_square_feet: row['CARPORT_SQUARE_FEET'],
          balcony_square_feet: row['BALCONY_SQUARE_FEET'],
          porch_square_feet: row['PORCH_SQUARE_FEET'],
          linear_feet_of_perimeter: row['LINEAR_FEET_OF_PERIMETER'],
          percent_complete: row['PERCENT_COMPLETE'],
          condition: row['CONDITION'],
          quality: row['QUALITY'],
          heat_vent_air_id: row['HEAT_VENT_AIR_ID'],
          heat_vent_air_description: row['HEAT_VENT_AIR_DESCRIPTION'],
          exterior: row['EXTERIOR'],
          interior: row['INTERIOR'],
          unit_type: row['UNIT_TYPE'],
          number_of_stories: row['NUMBER_OF_STORIES'],
          story_height: row['STORY_HEIGHT'],
          square_feet_of_sprinkler_coverage: row['SQUARE_FEET_OF_SPRINKLER_COVERAGE'],
          roof_type: row['ROOF_TYPE'],
          roof_cover: row['ROOF_COVER'],
          floor_cover: row['FLOOR_COVER'],
          foundation_type: row['FOUNDATION_TYPE'],
          number_of_rooms: row['NUMBER_OF_ROOMS'],
          number_of_bedrooms: row['NUMBER_OF_BEDROOMS'],
          number_of_bathrooms: row['NUMBER_OF_BATHROOMS'],
          number_of_units: row['NUMBER_OF_UNITS'],
          type_of_construction_id: row['TYPE_OF_CONSTRUCTION_ID'],
          type_of_construction_description: row['TYPE_OF_CONSTRUCTION_DESCRIPTION'],
          year_built: row['YEAR_BUILT'],
          year_remodeled: row['YEAR_REMODELED'],
          percent_remodeled: row['PERCENT_REMODELED'],
          adjusted_year_built: row['ADJUSTED_YEAR_BUILT'],
          age: row['AGE'],
          mobilehome_title_number: row['MOBILEHOME_TITLE_NUMBER'],
          mobilehome_serial_number: row['MOBILEHOME_SERIAL_NUMBER'],
          mobilehome_length: row['MOBILEHOME_LENGTH'],
          mobilehome_width: row['MOBILEHOME_WIDTH'],
          mobilehome_make: row['MOBILEHOME_MAKE'],
          improvement_value: row['IMPROVEMENT_VALUE'],
          new_construction_value_for_current_year: row['NEW_CONSTRUCTION_VALUE_FOR_CURRENT_YEAR'],
          new_growth_value_for_current_year: row['NEW_GROWTH_VALUE_FOR_CURRENT_YEAR'],
          building_permit_value: row['BUILDING_PERMIT_VALUE'],
          status: row['STATUS']
        }
      end
      # rubocop:enable Metrics/MethodLength

      def unique_by
        [:account_id, :building_num]
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num, :id).to_h
      end

      def model
        ::OkAssessor::Improvement
      end

      def file_name
        'View_OKPublicRecordImprovement.csv'
      end
    end
  end
end
