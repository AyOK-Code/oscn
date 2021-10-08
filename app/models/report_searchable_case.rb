# Database view that feeds a PowerBI report
class ReportSearchableCase
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_searchable_cases, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
