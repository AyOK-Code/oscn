module Importers
  module Doc
    class LinkOffenseCodes
      attr_accessor :offense_code_mapping

      def initialize
        @offense_code_mapping = ::Doc::OffenseCode.all.pluck(:statute_code, :id).to_h
      end

      def perform
        count = ::Doc::Sentence.where(doc_offense_code_id: nil).count
        bar = ProgressBar.new((count / 1000.0).ceil)

        ::Doc::Sentence.where(doc_offense_code_id: nil).in_batches(of: 1000).each do |sentences|
          bar.increment!
          sentences_to_update = []

          sentences.each do |sentence|
            offense_code_id = offense_code_mapping[sentence.statute_code]
            sentences_to_update << { id: sentence.id, doc_offense_code_id: offense_code_id } if offense_code_id.present?
          end

          batch_update_sentences(sentences_to_update) unless sentences_to_update.empty?
        end
      end

      private

      def batch_update_sentences(sentences_to_update)
        update_statements = sentences_to_update.map do |update|
          "(#{update[:id]}, #{update[:doc_offense_code_id]})"
        end

        values = update_statements.join(', ')
        sql = <<-SQL
          UPDATE doc_sentences
          SET doc_offense_code_id = updates.doc_offense_code_id
          FROM (VALUES #{values}) AS updates(id, doc_offense_code_id)
          WHERE doc_sentences.id = updates.id
        SQL

        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
