# Database view that feeds a PowerBI report
class ReportWarrants < ApplicationRecord
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_warrants, concurrently: false, cascade: true)
  end

  def readonly?
    true
  end
end
