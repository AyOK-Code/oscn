class ReportJuvenileFirearm < ApplicationRecord
  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, cascade: false)
  end

  def readonly?
    true
  end
end
