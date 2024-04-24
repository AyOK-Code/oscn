class AddUniqueConstraintToReportOklahomaEviction < ActiveRecord::Migration[7.0]
  def change
    remove_index :report_oklahoma_evictions, :court_case_id
    add_index :report_oklahoma_evictions, :court_case_id, unique: true
  end
end
