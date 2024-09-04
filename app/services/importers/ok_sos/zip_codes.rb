module Importers
  module OkSos
    class ZipCodes < BaseImporter
      def attributes(data)
        {
          name: data['zip_code']
        }
      end

      def unique_by
        [:name]
      end

      def import_class
        ::ZipCode
      end

      def ignore_duplicates
        true
      end
    end
  end
end
