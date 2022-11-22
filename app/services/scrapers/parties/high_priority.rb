module Scrapers
  module Parties
    class HighPriority
      def self.perform
        new.perform
      end

      def perform
        parties_oscn_ids = ::Party.without_html.where.not(oscn_id: nil).limit(parties_high_count).pluck(:oscn_id)
        bar = ProgressBar.new(parties_oscn_ids.count)
        puts "#{parties_oscn_ids.count} are missing html"

        parties_oscn_ids.each do |oscn_id|
         job_id = PartyWorker
            .set(queue: :high)
            .perform_async(oscn_id)

            puts job_id
            
          bar.increment!
        end
      end

      def parties_high_count
        ENV.fetch('PARTIES_HIGH_PRIORITY', 5_000).to_i
      end
    end
  end
end
