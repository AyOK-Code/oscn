# Database view that feeds a PowerBI report
class ReportOcsoOscnJoin < ApplicationRecord
  scope :three_days_old, -> { where('scraped_at < ?', 3.days.ago) }

  def readonly?
    true
  end
end
