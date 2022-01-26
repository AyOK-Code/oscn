module Importers
  module Doc
    class Profile
      attr_accessor :filename

      def initialize
        @filename = 'lib/data/Vendor_Profile_Extract_Text.dat'
      end

      def perform
        fields = [11,30,30,30,5,9,40,9,1,40,40,2,2,4,40,10]
        field_pattern = "A#{fields.join('A')}"
        bar = ProgressBar.new(File.read(filename).scan(/\n/).length)

        File.foreach(filename) do |line|
          bar.increment!
          row = line.unpack(field_pattern)
          data = row.map { |f| f.squish }
          profile = ::Doc::Profile.find_or_initialize_by(
            doc_number: data[0]
          )
          profile.assign_attributes(
            last_name: data[1],
            first_name: data[2],
            middle_name: data[3],
            suffix: data[4],
            last_move_date: data[5].present? ? Date.parse(data[5]) : '',
            facility: data[6],
            birth_date: data[7].present? ? Date.parse(data[7]) : '',
            sex: data[8] === 'M' ? 'male' : 'female',
            race: data[9],
            hair: data[10],
            height_ft: data[11],
            height_in: data[12],
            weight: data[13],
            eye: data[14],
            status: data[15] === 'Active' ? 'active' : 'inactive'
          )
          profile.save!
        end
      end
    end
  end
end
