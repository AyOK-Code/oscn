module Importers
  module OkSos
    class NameStatuses < BaseImporter
      def attributes(data)
        {
          name_status_id: data['name_status_id'],
          name_status: data['status']
        }
      end
    end
  end
end