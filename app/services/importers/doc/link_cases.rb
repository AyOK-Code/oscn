module Importers
  module Doc
    class LinkCases
      attr_accessor :sentences, :bar, :court_case_mapping

      def initialize
        @sentences = ::Doc::Sentence.where(sentencing_county: 'OKLAHOMA COUNTY COURT')
        @bar = ProgressBar.new(@sentences.count)
        @court_case_mapping = ::CourtCase.all.pluck(:case_number, :id).to_h
      end

      def perform
        sentences.each do |sentence|
          bar.increment!
          cc = match_regex(sentence)
          sentence.update(court_case_id: cc) if cc.present?
        end
      end

      private

      def match_regex(sentence)
        if /CF-\d{4}-[0-9]{1,4}/ =~ sentence.crf_number
          court_case_mapping[sentence.crf_number]
        elsif /\d{4}-[0-9]{1,4}/ =~ sentence.crf_number
          court_case_mapping["CF-#{sentence.crf_number}"]
        elsif /\d{2}-[0-9]{1,4}/ =~ sentence.crf_number
          court_case_mapping["CF-20#{sentence.crf_number}"]
        end
      end
    end
  end
end
