module Importers
  module Doc
    class Status
      attr_accessor :filename, :fields, :field_pattern, :bar, :doc_mapping, :dir

      def initialize(dir)
        @dir = dir
        @filename = File.open("doc/#{dir}/Vendor_Profile_Extract_Text.dat")
        @fields = [11, 30, 30, 30, 5, 9, 40, 9, 1, 40, 40, 2, 2, 4, 40, 10]
        @field_pattern = "A#{fields.join('A')}"
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
      end

      def perform
        puts "Importing #{dir}-01"
        File.foreach(filename) do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)

          save_status(data)
        end
      end

      private

      def find_status(data)
        profile = doc_mapping[data[0].to_i]
        return if profile.nil?
        status = ::Doc::Status.find_or_initialize_by(
          doc_profile_id: doc_mapping[data[0].to_i],
          date: parse_date("#{dir}-01"),
          facility: data[6]
        )
      end

      def save_status(data)
        status = find_status(data)
        return if status.nil?
        status.save
      end

      def parse_date(date)
        date.present? ? Date.parse(date) : nil
      end
    end
  end
end
