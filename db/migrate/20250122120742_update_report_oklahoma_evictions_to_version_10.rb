class UpdateReportOklahomaEvictionsToVersion10 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_oklahoma_evictions,
      version: 10,
      revert_to_version: 9,
      materialized: true
  end
end
