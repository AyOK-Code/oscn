module Importers
  module Doc
    class BaseDocImporter
      def validate
        expected_row_length = fields.sum
        first_row_length = @file.body.string.split("\r\n")[0].length
        raise "File not valid in #{self.class.name}" if expected_row_length != first_row_length
      end
    end
  end
end
