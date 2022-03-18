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
        file.body.string.split("\r\n").each do |line|
          bar.increment!
          dat = line.unpack(field_pattern).map(&:squish)

          save_profile(data)
        end
      end

      private

      def find_profile(data)
        ::Doc::Profile.find_or_initialize_by(
          doc_number: data[0]
        )
      end

      def save_profile(data)
        profile = find_profile(data)

        profile.assign_attributes(
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
        )
        profile.save!
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
