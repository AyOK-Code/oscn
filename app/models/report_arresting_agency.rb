# Database view that feeds a PowerBI report
class ArrestingAgency
  def self.refresh
    Scenic.database.refresh_materialized_view(:report_arresting_agencies, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
