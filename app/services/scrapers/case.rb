# Scraper
module Scrapers
  # Handles which cases to update first
  class Case
    def self.perform
      new.perform
    end

    def perform
      # TODO: How to make sure that if a day is missed, it gets captured later?
      # TODO: Capture results and send via email or slack message
      Scrapers::NewCases.perform(Date.today)
      Scrapers::HighPriority.perform(days_ago: 1)
      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
      update_cases
    end

    private

    def update_cases
      recently_updated = ::CourtCase.last_scraped(12.hours.ago)
      bar = ProgressBar.new(recently_updated.count)
      puts "Updating information for #{recently_updated.count} cases"
      recently_updated.each do |c|
        Importers::CourtCase.perform(c)
        bar.increment!
      end
    end
  end
end
