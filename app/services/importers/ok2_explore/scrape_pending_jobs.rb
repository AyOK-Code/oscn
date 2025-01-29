module Importers
  module Ok2Explore
    class ScrapePendingJobs < ApplicationService
      attr_reader :record_limit, :retry_attempts, :bar

      def initialize(record_limit)
        @record_limit = record_limit
        @retry_attempts = 0
      end

      def perform
        needs_scraping = ::Ok2Explore::ScrapeJob.where(is_success: false,
                                                     is_too_many_records: false).sample(record_limit.to_i)

        if needs_scraping.count.zero?
          puts 'No records to scrape'
          return true
        end
        raise 'Unable to complete processing of death records.' if retry_attempts > retry_limit

        @bar = ProgressBar.new(needs_scraping.count)
        needs_scraping.each do |record|
          bar.increment!
          ScrapeJob.perform(record, bar: bar)
        end

        bar.puts 'Run complete. Restarting to try for failed or newly generated records.'
        bar.puts "Retry attempt was: #{@retry_attempts}"
        @retry_attempts += 1
        perform
      end

      def retry_limit
        ENV.fetch('OK2EXPLORE_JOB_RETRIES', 5)
      end
    end
  end
end