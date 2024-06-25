module Importers
  module OkSos
    class CorpStatuses < BaseImporter
      def attributes(data)
        {
          status_id: data['status_id'],
          status_description: data['status_description']
        }
      end

      def update_by
        [:status_id]
      end
    end
  end
end
