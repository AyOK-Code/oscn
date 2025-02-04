module Importers
  module Ok2Explore
    class ScrapePendingJobs < ApplicationService
      attr_reader :record_limit, :bar

      def initialize(record_limit)
        @record_limit = record_limit
        super()
      end

      def perform
        needs_scraping = ::Ok2Explore::ScrapeJob.where(is_success: false,
                                                       is_too_many_records: false).sample(record_limit.to_i)

        if needs_scraping.count.zero?
          puts 'No records to scrape'
          return true
        end

        @bar = ProgressBar.new(needs_scraping.count)
        needs_scraping.each do |record|
          bar.increment!
          ScrapeJob.perform(record, bar: bar)
        end

        bar.puts 'Run complete.'
      end
    end
  end
end
