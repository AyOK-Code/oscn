class UpdateReportOklahomaEvictionsToVersion4 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_oklahoma_evictions, version: 4, revert_to_version: 3
  end
end
