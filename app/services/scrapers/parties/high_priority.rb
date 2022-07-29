module Scrapers
  module Parties
    # Updates html for parties that have been on the docket in the past week or parties without html (new parties)
    class HighPriority
      def self.perform
        new.perform
      end

      def perform
        parties_oscn_ids = ::Party.without_html.limit(parties_high_count).pluck(:oscn_id)

        bar = ProgressBar.new(parties_oscn_ids.count)
        puts "#{parties_oscn_ids.count} are missing html"

        parties_oscn_ids.each do |oscn_id|
          PartyWorker.perform_async(oscn_id)
          bar.increment!
        end
      end

      def parties_high_count
        ENV.fetch('PARTIES_HIGH_PRIORITY', 10_000).to_i
      end
    end
  end
end
