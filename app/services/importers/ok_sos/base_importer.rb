module Importers
  module OkSos
    class BaseImporter < ApplicationService
      def perform
        do_import
      end

      def do_import
        columns = []
        Bucket.new.get_object(file_path).each_with_index do |row, i|
          if i.zero?
            columns = row.split('~')
            next
          end

          data = columns.zip(row).to_h
          import_row data
        end
      end

      def import_row data
        import_class.create(
          attributes
        )
      end

      def file_path
        "/ok_sos/#{import_type}.csv"
      end

      def import_type
        self.class.name.demodulize.underscore
      end

      def import_class
        klass_name = "::OkSos::#{self.class.name.demodulize}"
        Object.const_get(klass_name)
      end
    end
  end
end
