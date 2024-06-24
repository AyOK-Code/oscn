require 'csv'

module Importers
  module OkSos
    class BaseImporter < ApplicationService
      def perform
        do_import
      end

      def do_import
        file = Bucket.new.get_object(file_path).body.string
        rows = CSV.parse(file, col_sep: ",", quote_char:'"', headers: true).map(&:to_h)
        rows.each do |row|
          import_row row
        end
      end

      def import_row(data)
        import_class.create(
          attributes(data)
        )
      end

      def file_path
        "/ok_sos/#{import_type}.csv"
      end

      def import_type
        self.class.name.demodulize.underscore
      end

      def import_class
        klass_name = "::OkSos::#{self.class.name.demodulize.singularize}"
        Object.const_get(klass_name)
      end

      def parse_date(date)
        Date::strptime(date, "%m/%d/%Y")
      end
    end
  end
end
