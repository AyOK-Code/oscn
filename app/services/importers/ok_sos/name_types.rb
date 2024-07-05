module Importers
  module OkSos
    class NameTypes < BaseImporter
      def attributes(data)
        {
          name_type_id: data['name_type_id'],
          name_type: data['name_description']
        }
      end

      def unique_by
        [:name_type_id]
      end
    end
  end
end
