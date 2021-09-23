class UpdateReportArrestingAgenciesToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :report_arresting_agencies, version: 2, revert_to_version: 1, materialized: true
  end
end
