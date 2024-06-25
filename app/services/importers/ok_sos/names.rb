module Importers
  module OkSos
    class Names < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          name_id: data['name_id'],
          name: data['name'],
        }
      end

      def update_by
        [:name_id]
      end
    end
  end
end