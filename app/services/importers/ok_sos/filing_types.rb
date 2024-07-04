module Importers
  module OkSos
    class FilingTypes < BaseImporter
      def attributes(data)
        {
          filing_type_id: data['filing_type_id'],
          filing_type: data['filing_type']
        }
      end

      def unique_by
        [:filing_type_id]
      end
    end
  end
end