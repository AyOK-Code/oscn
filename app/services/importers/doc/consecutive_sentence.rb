module Importers
  module Doc
    class ConsecutiveSentence
      attr_accessor :file, :bar, :fields, :field_pattern, :sentence_mapping

      def initialize(dir)
        @file = Bucket.new.get_object("doc/#{dir}/Vendor_Consecutive_Extract_Text.dat")
        @bar = ProgressBar.new(file.body.string.split("\r\n").size)
        @fields = [13, 13]
        @field_pattern = "A#{fields.join('A')}"
        @sentence_mapping = ::Doc::Sentence.all.pluck(:sentence_id, :id).to_h
      end

      def perform
        sentences_to_update = []

        file.body.string.split("\r\n").each do |line|
          bar.increment!
          data = line.unpack(field_pattern).map(&:squish)
          collect_sentences_to_update(data, sentences_to_update)
        end

        batch_update_sentences(sentences_to_update)
      end

      private

      def collect_sentences_to_update(data, sentences_to_update)
        sentence_id = sentence_mapping[data[0]]
        consecutive_sentence_id = sentence_mapping[data[1]]

        sentences_to_update << { id: sentence_id, consecutive_to_sentence_id: consecutive_sentence_id }
      end

      def batch_update_sentences(sentences_to_update)
        sentences_to_update.each_slice(1000) do |batch|
          update_statements = batch.map do |update|
            "(#{update[:id]}, #{update[:consecutive_to_sentence_id]})"
          end

          values = update_statements.join(', ')
          sql = <<-SQL
                  UPDATE doc_sentences
                  SET consecutive_to_sentence_id = updates.consecutive_to_sentence_id
                  FROM (VALUES #{values}) AS updates(id, consecutive_to_sentence_id)
                  WHERE doc_sentences.id = updates.id
          SQL

          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
