class UpdateReportOklahomaEvictionsToVersion9 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_oklahoma_evictions,
      version: 9,
      revert_to_version: 8,
      materialized: true
  end
end
