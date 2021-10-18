# Scraper
module Scrapers
  # Handles which cases to update first
  class Case
    def self.perform
      new.perform
    end

    def perform
      # TODO: Capture results and send via email or slack message
      counties.each do |county|
        Scrapers::NewCases.perform(county, days_ago: 7)
        Scrapers::HighPriority.perform(county, days_ago: 7)
      end

      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
    end

    def counties
      ENV['COUNTIES'].split(',') # TODO: Change to ENV variable
    end
  end
end
