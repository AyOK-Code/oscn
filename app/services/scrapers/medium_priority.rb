module Scrapers
  # Scrape open court cases that have not been updated in two weeks
  class MediumPriority
    attr_accessor :cases, :days_ago

    def initialize(days_ago: 14, limit: 7500)
      @days_ago = days_ago
      @cases = CourtCase.active.older_than(14.days.ago).limit(limit)
    end

    def self.perform(days_ago: 14)
      new(days_ago: days_ago).perform
    end

    def perform
      puts "#{cases.count} are older #{days_ago} days"
      bar = ProgressBar.new(cases.count)

      cases.each do |c|
        CourtCaseWorker.perform_async({ county: c.county.name, case_number: c.case_number, scrape_case: true })
        bar.increment!
      end
    end
  end
end
