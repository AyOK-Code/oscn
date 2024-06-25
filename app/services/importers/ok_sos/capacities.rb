module Importers
  module OkSos
    class Capacities < BaseImporter
      def attributes(data)
        {
          capacity_id: data['capacity_id'],
          description: data['description']
        }
      end

      def update_by
        [:capacity_id]
      end
    end
  end
end