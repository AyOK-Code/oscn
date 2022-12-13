module Importers
  module Doc
    class Sentence
      attr_accessor :file, :fields, :field_pattern, :bar, :doc_mapping, :sentence_mapping

      def initialize(dir)
        @sentences = []
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_sentence_Extract_Text.dat")
        @fields = [11, 20, 20, 40, 40, 8, 40, 13, 13]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(file.body.string.split("\r\n").size)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @sentence_mapping = ::Doc::OffenseCode.pluck(:statute_code, :id).to_h
      end

      def perform
        file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)

          @sentences << find_and_save_sentence(data)
        end
        @sentences.compact!
        ::Doc::Sentence.upsert_all(@sentences ,unique_by: [:doc_profile_id, :sentence_id])
      end

      private

      def find_and_save_sentence(data)
        profile_id = doc_mapping[data[0].to_i]
        return if profile_id.blank?

        save_sentence(data)
      end

      def save_sentence(data)
        {
          doc_profile_id: doc_mapping[data[0].to_i],
          sentence_id: data[1],
          sentencing_county: data[4],
          consecutive_to_sentence_id: data[2],
          js_date: data[5].present? ? Date.parse(data[5]) : '',
          crf_number: data[6],
          statute_code: data[3],
          incarcerated_term_in_years: data[7].to_f,
          probation_term_in_years: data[8].to_f,
          is_death_sentence: data[7].to_i == 9999,
          is_life_sentence: data[7].to_i == 8888,
          is_life_no_parole_sentence: data[7].to_i == 7777
        }
      end
    end
  end
end
