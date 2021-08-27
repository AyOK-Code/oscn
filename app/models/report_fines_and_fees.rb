# Database view that feeds a PowerBI report
class ReportFinesAndFees
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_fines_and_fees, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
