module Importers
  module Doc
    class Alias
      attr_accessor :filename

      def initialize
        @filename = 'lib/data/Vendor_Alias_Extract_Text.dat'
      end

      def perform
        fields = [11,30,30,30,5]
        field_pattern = "A#{fields.join('A')}"
        bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
        doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        missing = []

        File.foreach(filename) do |line|
          bar.increment!
          row = line.unpack(field_pattern)
          data = row.map { |f| f.squish }
          profile_id = doc_mapping[row[0].to_i]
          if profile_id.blank?
            missing << [row]
            next
          end

          doc_alias = ::Doc::Alias.find_or_initialize_by(
            doc_profile_id: doc_mapping[data[0].to_i],
            last_name: data[1],
            first_name: data[2],
            middle_name: data[3],
            suffix: data[4]
          )
          doc_alias.save!
        end
      end
    end
  end
end
