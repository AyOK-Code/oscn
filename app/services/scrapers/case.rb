# Scraper
module Scrapers
  # Handles which cases to update first
  class Case
    def self.perform
      new.perform
    end

    def perform
      # TODO: Capture results and send via email or slack message
      Scrapers::NewCases.perform(days_ago: 7)
      Scrapers::HighPriority.perform(days_ago: 7)
      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
    end
  end
end
