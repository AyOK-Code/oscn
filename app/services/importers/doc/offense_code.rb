module Importers
  module Doc
    class OffenseCode
      attr_accessor :file, :fields, :field_pattern, :bar

      def initialize(dir)
        @statutes = []
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Offense_Extract_Text.dat")
        @fields = [38, 40, 1]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(@file.body.string.split("\r\n").size)
      end

      def perform
        @file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)

          @statutes << save_statute(data)
        end
        @statutes.compact!
        ::Doc::OffenseCode.upsert_all(@statutes ,unique_by: [:statute_code,:description,:is_violent])
      end

      private

      def save_statute(data)
        {
          statute_code: data[0],
          description: data[1],
          is_violent: data[2] == 'Y'
        }
      end
    end
  end
end
