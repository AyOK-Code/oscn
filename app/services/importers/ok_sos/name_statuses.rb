module Importers
  module OkSos
    class NameStatuses < BaseImporter
      def attributes(data)
        {
          name_status_id: data['name_status_id'],
          name_status: data['status']
        }
      end

      def unique_by
        [:name_status_id]
      end
    end
  end
end
