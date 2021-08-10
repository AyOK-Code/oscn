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
      Scrapers::NewCases.perform(Date.yesterday)
      Scrapers::HighPriority.perform(days_ago: 7)
      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
      update_cases
      refresh_materialized_views
    end

    def update_cases
      recently_updated = ::CourtCase.with_html.last_scraped(36.hours.ago)
      bar = ProgressBar.new(recently_updated.count)
      docket_event_types = DocketEventType.pluck(:code, :id).to_h
      pleas = Plea.pluck(:name, :id).to_h
      verdicts = Verdict.pluck(:name, :id).to_h
      puts "Updating information for #{recently_updated.count} cases"

      recently_updated.each do |c|
        Importers::CourtCase.perform(c, docket_event_types, pleas, verdicts)
        bar.increment!
      end
    end

    def refresh_materialized_views
      CreateReportFinesAndFees.refresh
    end
  end
end
