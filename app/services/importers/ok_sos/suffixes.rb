module Importers
  module OkSos
    class Suffixes < BaseImporter
      def attributes(data)
        {
          suffix_id: data['suffix_id'],
          suffix: data['suffix']
        }
      end

      def unique_by
        [:suffix_id]
      end
    end
  end
end