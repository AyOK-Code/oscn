module Scrapers
  # Lowest priority for update
  class LowPriority
    attr_accessor :cases

    def initialize(days_ago: 90, limit: 7500)
      @cases = CourtCase.closed.older_than(days_ago.days.ago).limit(limit)
    end

    def self.perform(days_ago: 90, limit: 2500)
      new(days_ago: days_ago, limit: limit).perform
    end

    def perform
      puts "Pulling #{cases.count} low priority cases"
      bar = ProgressBar.new(cases.count)

      cases.each do |c|
        CourtCaseWorker.perform_async({ county: c.county.name, case_number: c.case_number, scrape_case: true })
        bar.increment!
      end
    end
  end
end
