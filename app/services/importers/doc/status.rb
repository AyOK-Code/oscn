module Importers
  module Doc
    class Status
      attr_accessor :filename, :fields, :field_pattern, :bar, :doc_mapping, :dir

      def initialize(dir)
        @statuses = []
        @dir = dir
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Profile_Extract_Text.dat")
        @fields = field_spacing(dir)
        @field_pattern = "A#{fields.join('A')}"
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @bar = ProgressBar.new(@file.body.string.split("\r\n").size)
      end

      def perform
        puts "Importing #{dir}"
        @file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)
          @statuses << save_status(data)
        end

        @statuses.compact!
        ::Doc::Status.upsert_all(@statuses, unique_by: :status_index)
      end

      private

      def find_status(data)
        profile = doc_mapping[data[0].to_i]
        return if profile.nil?

        {
          doc_profile_id: doc_mapping[data[0].to_i],
          date: parse_date("#{dir}-01"),
          facility: data[6]
        }
      end

      def save_status(data)
        status = find_status(data)
        return if status.nil?

        status
      end

      def parse_date(date)
        date.present? ? Date.parse(date) : nil
      end

      def field_spacing(dir)
        if parse_date("#{dir}-01") > parse_date('2021-12-31')
          [11, 30, 30, 30, 5, 8, 40, 8, 1, 40, 40, 2, 2, 4, 40, 10]
        else
          [11, 30, 30, 30, 5, 9, 40, 9, 1, 40, 40, 2, 2, 4, 40, 10]
        end
      end
    end
  end
end
