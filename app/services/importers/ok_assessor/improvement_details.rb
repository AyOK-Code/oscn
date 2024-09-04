require 'csv'

module Importers
  module OkAssessor
    class ImprovementDetails < BaseImporter
      attr_reader :improvements

      def attributes(row)
        {
          improvement_id: improvements[[row['ACCOUNT_NUM'], row['BUILDING_NUM'].to_i]],
          detail_type: row['DETAIL_TYPE'],
          detail_description: row['DETAIL_DESCRIPTION'],
          number_of_units: row['NUMBER_OF_UNITS'],
          status: row['STATUS']
        }
      end

      def prefetch_associations
        @improvements = improvements_ids_by_account_num_and_building_num
      end

      def improvements_ids_by_account_num_and_building_num
        ::OkAssessor::Improvement
          .joins(:account)
          .pluck('ok_assessor_accounts.account_num', :building_num, :id)
          .to_h do |x|
          [
            [x[0], x[1]],
            x[2]
          ]
        end
      end

      def model
        ::OkAssessor::ImprovementDetail
      end

      def unique_by
        [:improvement_id, :detail_type, :detail_description, :number_of_units]
      end

      def file_name
        'View_OKPublicRecordImprovementDetail.csv'
      end
    end
  end
end
