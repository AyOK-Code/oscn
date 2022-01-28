module Importers
  module Doc
    class Profile
      attr_accessor :filename, :fields, :field_pattern, :bar

      def initialize
        @filename = 'lib/data/Vendor_Profile_Extract_Text.dat'
        @fields = [11, 30, 30, 30, 5, 9, 40, 9, 1, 40, 40, 2, 2, 4, 40, 10]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
      end

      def perform
        File.foreach(filename) do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)
          profile = find_profile(data)

          save_profile(profile)
        end
      end

      private

      def find_profile(data)
        ::Doc::Profile.find_or_initialize_by(
          doc_number: data[0]
        )
      end

      def save_profile(profile)
        profile.save!(
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
      end
    end

    def parse_date(date)
      date.present? ? Date.parse(date) : ''
    end

    def parse_sex(sex)
      sex == 'M' ? 'male' : 'female'
    end

    def parse_status(data)
      data == 'Active' ? 'active' : 'inactive'
    end
  end
end
