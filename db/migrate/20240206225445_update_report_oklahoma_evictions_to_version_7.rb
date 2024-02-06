class UpdateReportOklahomaEvictionsToVersion7 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_oklahoma_evictions,
      version: 7,
      revert_to_version: 6,
      materialized: true
  end
end
