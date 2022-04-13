module Importers
  module Doc
    class LinkParties
      attr_accessor :sentences, :bar

      def initialize
        @sentences = ::Doc::Sentence.where(sentencing_county: 'OKLAHOMA COUNTY COURT').where.not(court_case_id: nil)
        @bar = ProgressBar.new(@sentences.count)
      end

      def perform
        puts "Processing #{@sentences.count} sentences"
        results = { success: 0, failed: 0 }

        sentences.each do |sentence|
          bar.increment!
          next if sentence.court_case_id.nil?

          parties = sentence.court_case.parties.defendant

          next if parties.size.zero?

          fz = FuzzyMatch.new(parties, read: :last_first)
          match = fz.find("#{sentence.profile.last_name} #{sentence.profile.first_name}", threshold: 0.8)

          if match.present?
            match.update(doc_profile_id: sentence.doc_profile_id) if match.doc_profile_id.nil?
            results[:success] += 1
          else
            binding.pry
          end
        end
        puts results
      end
    end
  end
end
