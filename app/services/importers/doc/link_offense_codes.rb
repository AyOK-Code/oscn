module Importers
  module Doc
    class LinkOffenseCodes
      attr_accessor :sentences, :bar, :offense_code_mapping

      def initialize(relink = false)
        @sentences = relink ? ::Doc::Sentence.all : ::Doc::Sentence.where(doc_offense_code_id: nil)
        @bar = ProgressBar.new(@sentences.count)
        @offense_code_mapping = ::Doc::OffenseCode.all.pluck(:statute_code, :id).to_h
      end

      def perform
        sentences.each do |sentence|
          bar.increment!
          offense_code_id = offense_code_mapping[sentence.statute_code]
          sentence.update(doc_offense_code_id: offense_code_id) if offense_code_id.present?
        end
      end
    end
  end
end
