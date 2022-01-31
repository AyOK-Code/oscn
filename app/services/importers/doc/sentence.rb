module Importers
  module Doc
    class Sentence
      attr_accessor :filename, :fields, :field_pattern, :bar, :doc_mapping, :sentence_mapping

      def initialize
        @filename = File.open('lib/data/Vendor_sentence_Extract_Text.dat')
        # @filename = Bucket.new.get_object('Vendor_sentence_Extract_Text.dat')
        @fields = [11, 40, 40, 9, 40, 12, 14]
        @field_pattern = "A#{fields.join('A')}"
        # @bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @sentence_mapping = ::Doc::OffenseCode.pluck(:statute_code, :id).to_h
      end

      def perform
        File.foreach(filename) do |line|
          # bar.increment!
          data = line.unpack(field_pattern).map(&:squish)
          find_and_save_sentence(data)
        end
      end

      private

      def find_and_save_sentence(data)
        profile_id = doc_mapping[data[0].to_i]
        return if profile_id.blank?

        save_sentence(data)
      end

      def find_sentence(data)
        ::Doc::Sentence.find_or_initialize_by(
          doc_profile_id: doc_mapping[data[0].to_i],
          sentencing_county: data[2],
          js_date: data[3].present? ? Date.parse(data[3]) : ''
        )
      end

      def save_sentence(data)
        sentence = find_sentence(data)

        sentence.assign_attributes(
          {
            crf_number: data[4],
            statute_code: data[1],
            incarcerated_term_in_years: data[5],
            probation_term_in_years: data[6],
            is_death_sentence: data[5].to_i == 9999,
            is_life_sentence: data[5].to_i == 8888,
            is_life_no_parole_sentence: data[5].to_i == 7777
          }
        )
        sentence.save!
      end
    end
  end
end
