module Importers
  module Doc
    class OldExits
      attr_accessor :file, :doc_mapping

      def initialize
        @file = CSV.parse(File.open('lib/data/2017/OffenderExit.csv'), headers: true)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
      end

      def perform
        bar = ProgressBar.new(file.count)

        success = { success: 0, failure: 0 }
        file.each do |row|
          bar.increment!
          id = doc_mapping[row['DOCNum'].to_i]
          next unless id.present?

          begin
            ::Doc::Status.find_or_create_by(
              doc_profile_id: id,
              facility: row['ExitReason']&.squish,
              reason: row[3]&.squish,
              date: parse_date(row['ExitDate'])
            )

            success[:success] += 1
          rescue StandardError => e
            success[:failure] += 1
          end
        end
      end

      def parse_date(date_string)
        Date.parse(date_string)
      end
    end
  end
end
