module Scrapers
  # Handles which cases to update first
  class WarrantsView
    def self.perform
      new.perform
    end

    def perform
      data = ReportOcsoOscnJoin.three_days_old.pluck(:clean_case_number)
      data.each do |row|
        OneOffCaseWorker
          .set(queue: :high)
          .perform_async('Oklahoma', row[0])
      end
    end
  end
end