class ReportOcisCountiesEviction < ApplicationRecord
  belongs_to :county
  belongs_to :court_case

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, cascade: false)
  end

  def readonly?
    true
  end
end
