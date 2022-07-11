module Scrapers
  # Lowest priority for update
  class LowPriority
    attr_accessor :cases

    def initialize(days_ago: 90, limit: low_count)
      @cases = CourtCase.closed.older_than(days_ago.days.ago).limit(limit)
    end

    def self.perform(days_ago: 90)
      new(days_ago: days_ago).perform
    end

    # performs main concern is adding jobs to the queue
    def perform
      puts "Pulling #{cases.count} low priority cases"
      bar = ProgressBar.new(cases.count)

      cases.each do |c|
        county = c.county

        case_number = c.case_number
        worker_args = JSON.dump({ county_id: county.id, case_number: case_number, scrape_case: true })

        CourtCaseWorker
          .set(queue: :low)
          .perform_async(worker_args)
        bar.increment!
      end
    end

    private

    def low_count
      ENV.fetch('LOW_PRIORITY', 10_000).to_i
    end
  end
end
