module Importers
  module Doc
    class Profile
      attr_accessor :file, :fields, :field_pattern, :bar

      def initialize(dir)
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Profile_Extract_Text.dat")
        @fields = field_spacing(dir)
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(file.body.string.split("\r\n").size)
      end

      def perform
        profiles = []

        file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)          

          profiles << save_profile(data)

          if profiles.size >= 10_000
            ::Doc::Profile.upsert_all(profiles, unique_by: :doc_number)
            profiles = []
          end
        end

        ::Doc::Profile.upsert_all(profiles, unique_by: :doc_number) if profiles.present?
      end

      private

      def save_profile(data)
        {
          doc_number: data[0],
          last_name: data[1],
          first_name: data[2],
          middle_name: data[3],
          suffix: data[4],
          last_move_date: parse_date(data[5]),
          facility: data[6],
          birth_date: parse_date(data[7]),
          sex: parse_sex(data[8]),
          race: data[9],
          hair: data[10],
          height_ft: data[11],
          height_in: data[12],
          weight: data[13],
          eye: data[14],
          status: parse_status(data[15])
        }
      end

      def parse_date(date)
        date.present? ? Date.parse(date) : nil
      end

      def parse_sex(sex)
        sex == 'M' ? 'male' : 'female'
      end

      def parse_status(data)
        data == 'Active' ? 'active' : 'inactive'
      end

      def field_spacing(_dir)
        [10, 30, 30, 30, 4, 8, 50, 8, 1, 60, 60, 1, 2, 3, 60, 10]
      end
    end
  end
end
