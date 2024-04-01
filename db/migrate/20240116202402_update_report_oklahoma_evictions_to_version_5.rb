class UpdateReportOklahomaEvictionsToVersion5 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_oklahoma_evictions, version: 5, revert_to_version: 4
  end
end
