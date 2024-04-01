class UpdateReportOklahomaEvictionsToVersion6 < ActiveRecord::Migration[7.0]
  def change
    drop_view :report_oklahoma_evictions, revert_to_version: 5

    create_view :report_oklahoma_evictions,
      version: 6,
      materialized: true

    add_index :report_oklahoma_evictions, :court_case_id
    add_index :report_oklahoma_evictions, :case_filed_on
    add_index :report_oklahoma_evictions, :case_closed_on
    add_index :report_oklahoma_evictions, :max_judgement_date
  end
end
