class ReportCriminalCase < ApplicationRecord
  belongs_to :court_case
  belongs_to :county

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, cascade: false)
  end

  def readonly?
    true
  end
end
