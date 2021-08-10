# Scraper
module Scrapers
  # Handles which cases to update first
  class Case
    def self.perform
      new.perform
    end

    def perform
      # TODO: Capture results and send via email or slack message
      Scrapers::NewCases.perform(days_ago: 3)
      Scrapers::HighPriority.perform(days_ago: 3)
      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
      refresh_materialized_views
    end

    def refresh_materialized_views
      CreateReportFinesAndFees.refresh
    end
  end
end
