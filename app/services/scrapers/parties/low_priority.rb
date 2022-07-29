module Scrapers
  module Parties
    class LowPriority
      attr :parties_oscn_ids
      def initialize(days_ago: 90, limit: low_count)
        @parties_oscn_ids = ::Party.older_than(days_ago.days.ago).limit(limit).pluck(:oscn_id)
      end

      def self.perform(days_ago: 90)
        new(days_ago: days_ago).perform
      end

      def perform
        puts "Pulling #{parties_oscn_ids.count} low priority parties"
        bar = ProgressBar.new(parties_oscn_ids.count)

        parties_oscn_ids.each do |oscn_id|
          PartyWorker.perform_async(oscn_id)
          bar.increment!
        end
      end

      private

      def low_count
        ENV.fetch('PARTIES_LOW_PRIORITY', 10_000).to_i
      end
    end
  end
end
