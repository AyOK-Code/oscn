module Importers
  module Doc
    class OffenseCode
      attr_accessor :filename, :fields, :field_pattern, :bar

      def initialize
        @filename = Bucket.new.get_object('Vendor_Offense_Extract_Text.dat')
        @fields = [38, 40, 1]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
      end

      def perform
        File.foreach(filename) do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)

          save_statute(data)
        end
      end

      private

      def save_statute(data)
        statute = ::Doc::OffenseCode.find_or_initialize_by(
          statute_code: data[0],
          description: data[1],
          is_violent: data[2] == 'Y'
        )
        statute.save!
      end
    end
  end
end
