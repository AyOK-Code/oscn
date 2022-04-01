module Importers
  module Doc
    class OldSentences
      attr_accessor :file, :doc_mapping, :sentences_mapping

      def initialize
        @file = CSV.parse(File.open('lib/data/2017/OffenderSentence.csv'), headers: true, liberal_parsing: true)
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @sentences_mapping = ::Doc::Sentence.pluck(:sentence_id, :id).to_h
      end

      def perform
        bar = ProgressBar.new(file.count)

        file.each do |row|
          bar.increment!
          id = doc_mapping[row['DOCNum'].to_i]
          binding.pry
          next unless id.present?
        end
      end

      def parse_date(date_string)
        Date.parse(date_string)
      end
    end
  end
end
