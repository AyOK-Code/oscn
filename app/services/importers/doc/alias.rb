module Importers
  module Doc
    class Alias
      attr_accessor :file, :fields, :field_pattern, :bar, :doc_mapping, :dir

      def initialize(dir)
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Alias_Extract_Text.dat")
        @fields = [11, 30, 30, 30, 5]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(@file.body.string.split("\r\n").size)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
      end

      def perform
        file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)
          profile_id = doc_mapping[row[0].to_i]
          next if profile_id.blank?

          save_alias(data)
        end
      end

      private

      def save_alias(data)
        doc_alias = ::Doc::Alias.find_or_initialize_by(
          doc_profile_id: doc_mapping[data[0].to_i],
          doc_number: data[0],
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
