module Importers
  module Doc
    class OldSentences
      attr_accessor :file, :doc_mapping, :sentences_mapping

      def initialize
        @doc_mapping = ::Doc::Profile.pluck(:doc_number, :id).to_h
        @sentences_mapping = ::Doc::Sentence.pluck(:sentence_id, :id).to_h
      end

      def perform
        bar = ProgressBar.new(1_275_000)
        skipped = []

        CSV.foreach(File.open('lib/data/2017/OffenderSentence.csv'), headers: true, liberal_parsing: true) do |row|
          bar.increment!

          if doc_mapping[row['DOCNum'].to_i].nil?
            skipped << row['DOCNum'].to_i
            next
          else
            ::Doc::HistoricalSentence.find_or_create_by!(
              external_id: row['Id'],
              doc_profile_id: doc_mapping[row['DOCNum'].to_i],
              order_id: row['OrderID'],
              charge_seq: row['ChargeSeq'],
              crf_num: row['CRFNum'],
              convict_date: row['ConvictDate'],
              court: row['Court'],
              statute_code: row['StatuteCode'],
              offence_description: row['OffenceDescription'],
              offence_comment: row['OffenceComment'],
              sentence_term_code: row['SentenceTermCode'],
              years: row['Years'],
              months: row['Months'],
              days: row['Days'],
              sentence_term: row['SentenceTerm'],
              start_date: row['StartDate'],
              end_date: row['EndDate'],
              count_num: row['CountNum'],
              order_code: row['OrderCode'],
              consecutive_to_count: row['ConsecutiveToCount'],
              charge_status: row['ChargeStatus']
            )
          end
        end
      end

      def parse_date(date_string)
        Date.parse(date_string)
      end
    end
  end
end
