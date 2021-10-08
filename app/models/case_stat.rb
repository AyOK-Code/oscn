# View that gives some high level case statistics (Drop?)
class CaseStat < ApplicationRecord
  belongs_to :court_case

  def self.refresh
    Scenic.database.refresh_materialized_view(:case_stats, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
