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
          return if court_case.blank?

          sentence.update(court_case_id: court_case.id) if court_case.match_name(sentence, court_case)
        end
      end

      private

      def match_name(sentence, court_case)
        party_names = court_case.parties.map{|party| "#{party.first_name} #{party.last_name}" }
        profile_name = "#{sentence.profile.first_name} #{sentence.profile.last_name}"
        name_match_with_score = FuzzyMatch.new(party_names).find(profile_name).find_with_score
        dice_match_score = name_match_with_score[1]
        levenshtein_match_score = name_match_with_score[2]
        [dice_match_score && levenshtein_match_score].any? { |v| v >= 0.5 }
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
