module Importers
  module OkSos
    class Suffixes < BaseImporter
      def attributes(data)
        {
          suffix_id: data['suffix_id'],
          suffix: data['suffix']
        }
      end
    end
  end
end