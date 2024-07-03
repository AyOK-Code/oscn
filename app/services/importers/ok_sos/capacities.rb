module Importers
  module OkSos
    class Capacities < BaseImporter
      def attributes(data)
        {
          capacity_id: data['capacity_id'],
          description: data['description']
        }
      end
    end
  end
end