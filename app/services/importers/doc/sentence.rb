module Importers
  module Doc
    class Sentence
      attr_accessor :filename

      def initialize
        @filename = 'lib/data/Vendor_sentence_Extract_Text.dat'
        # @filename = 'spec/fixtures/importers/doc/Vendor_sentence_Extract_Text.dat'
      end

      def perform
        fields = [11,40,40,9,40,12,14]
        field_pattern = "A#{fields.join('A')}"
        bar = ProgressBar.new(File.read(filename).scan(/\n/).length)
        doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h

        File.foreach(filename) do |line|
          bar.increment!
          row = line.unpack(field_pattern)
          data = row.map { |f| f.squish }

          sentence = ::Doc::Sentence.find_or_initialize_by(
            doc_profile_id: doc_mapping[row[0].to_i],
            statute_code: row[1],
            sentencing_county: row[2],
            js_date: Date.parse(row[3]),
            crf_number: row[4],
            incarcerated_term_in_years: row[5],
            probation_term_in_years: row[6]
          )
          binding.pry
          # sentence.save!
        end
      end
    end
  end
end

# Importers::Doc::Profile.new.perform
