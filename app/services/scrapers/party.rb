# Scraper
module Scrapers
  # Handles which parties to update first
  class Party
    def self.perform
      new.perform
    end

    def perform
      Scrapers::Parties::HighPriority.perform
      Scrapers::Parties::LowPriority.perform
    end
  end
end
