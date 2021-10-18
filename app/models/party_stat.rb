# Database view that feeds a PowerBI report
class PartyStat < ApplicationRecord
  belongs_to :party

  def self.refresh
    Scenic.database.refresh_materialized_view(:party_stats, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
