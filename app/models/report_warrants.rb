# Database view that feeds a PowerBI report
class ReportWarrants
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_warrants, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
