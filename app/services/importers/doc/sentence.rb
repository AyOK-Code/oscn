require 'json'
module Importers
  module Doc
    class Sentence
      attr_accessor :file, :fields, :field_pattern, :bar, :doc_mapping

      def initialize(dir)
        @sentences = []
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Sentence_Extract_Text.dat")
        @fields = [10, 13, 30, 60, 8, 32, 20, 20]
        @field_pattern = "A#{fields.join('A')}"
        @bar = ProgressBar.new(file.body.string.split("\r\n").size)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
      end

      def perform
        file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)

          @sentences << find_and_save_sentence(data)

          next unless @sentences.size >= 10_000

          slice = @sentences.compact
          ::Doc::Sentence.upsert_all(slice, unique_by: [:doc_profile_id, :sentence_id])
          @sentences = []
        end
        slice = @sentences.compact
        ::Doc::Sentence.upsert_all(slice, unique_by: [:doc_profile_id, :sentence_id])
      end

      private

      def find_and_save_sentence(data)
        profile_id = doc_mapping[data[0].to_i]
        return if profile_id.blank?

        save_sentence(data)
      end

      def save_sentence(data)
        js_date = begin
          Date.parse(data[4])
        rescue StandardError
          nil
        end
        {
          doc_profile_id: doc_mapping[data[0].to_i],
          sentence_id: data[1],
          sentencing_county: data[3],
          js_date: js_date,
          crf_number: data[5],
          statute_code: data[2],
          incarcerated_term_in_years: data[6].to_f,
          probation_term_in_years: data[7].to_f,
          is_death_sentence: data[6].to_i == 9999,
          is_life_sentence: data[6].to_i == 8888,
          is_life_no_parole_sentence: data[6].to_i == 7777
        }
      end
    end
  end
end
