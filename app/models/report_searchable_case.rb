# Database view that feeds a PowerBI report
class ReportSearchableCase < ApplicationRecord
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_searchable_cases, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
