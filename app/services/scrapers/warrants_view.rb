module Scrapers
  # Handles which cases to update first
  class WarrantsView
    def self.perform
      new.perform
    end

    def perform
      data = ReportOcsoOscnJoin.three_days_old.pluck(:clean_case_number)
      data.each do |case_number|
        OneOffCaseWorker
          .set(queue: :high)
          .perform_async('Oklahoma', case_number)
      end
    end
  end
end
