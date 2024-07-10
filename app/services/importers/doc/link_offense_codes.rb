module Importers
  module Doc
    class LinkOffenseCodes
      attr_accessor :offense_code_mapping

      def initialize(relink: false)
        @offense_code_mapping = ::Doc::OffenseCode.all.pluck(:statute_code, :id).to_h
      end

      def perform
        missing = []
        count = ::Doc::Sentence.where(doc_offense_code_id: nil).count
        bar = ProgressBar.new((count / 1000).to_i)
        ::Doc::Sentence.where(doc_offense_code_id: nil).in_batches(of: 1000).each do |sentences|
          bar.increment!
          sentences.each do |sentence|
            offense_code_id = offense_code_mapping[sentence.statute_code]
            missing << sentence.statute_code if offense_code_id.nil?
            sentence.update(doc_offense_code_id: offense_code_id) if offense_code_id.present?
          end
        end

        missing.uniq.each do |statute_code|
          puts "Missing offense code for statute code: #{statute_code}"
        end
      end
    end
  end
end
