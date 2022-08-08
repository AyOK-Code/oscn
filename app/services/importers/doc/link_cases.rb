module Importers
  module Doc
    class LinkCases
      attr_accessor :sentences, :bar, :court_case_mapping

      def initialize(county)
        @sentences = ::Doc::Sentence.includes(:profile).where(sentencing_county: county)
        @bar = ProgressBar.new(@sentences.count)
        @court_case_mapping = ::CourtCase.all.includes(:parties).map { |v| [v.case_number, v] }.to_h
      end

      def perform
        puts "Processing #{@sentences.count} sentences"
        @results = []
        sentences.each do |sentence|
          bar.increment!
          court_case = match_regex(sentence)
          next if court_case.blank?

          sentence.update(court_case_id: court_case.id) if match_name(sentence, court_case)
        end
      end

      private

      def match_name(sentence, court_case)
        party_names = court_case.parties.map { |party| "#{party.first_name} #{party.last_name}" }
        profile_name = "#{sentence.profile.first_name} #{sentence.profile.last_name}"
        match_scores = FuzzyMatch.new(party_names).find_with_score(profile_name)
        match_scores.present? && [match_scores[1] && match_scores[2]].any? { |v| v >= 0.5 }
      end

      def match_regex(sentence)
        case sentence.crf_number
        when /CF-\d{4}-[0-9]{1,4}/
          court_case_mapping[sentence.crf_number]
        when /\d{4}-[0-9]{1,4}/
          court_case_mapping["CF-#{sentence.crf_number}"]
        when /\d{2}-[0-9]{1,4}/
          court_case_mapping["CF-20#{sentence.crf_number}"]
        end
      end
    end
  end
end
