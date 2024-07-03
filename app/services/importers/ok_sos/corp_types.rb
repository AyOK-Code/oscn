module Importers
  module OkSos
    class CorpTypes < BaseImporter
      def attributes(data)
        {
          corp_type_id: data['corp_type_id'],
          corp_type_description: data['corp_type']
        }
      end
    end
  end
end