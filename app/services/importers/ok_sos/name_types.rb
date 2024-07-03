module Importers
  module OkSos
    class NameTypes < BaseImporter
      def attributes(data)
        {
          name_type_id: data['name_type_id'],
          name_type: data['name_description']
        }
      end
    end
  end
end