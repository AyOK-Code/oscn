class CreateReportArrestingAgencies < ActiveRecord::Migration[6.1]
  def change
    create_view :report_arresting_agencies, materialized: true
    add_index :report_arresting_agencies, :title_code
    add_index :report_arresting_agencies, :filed_on
    add_index :report_arresting_agencies, :arresting_agency_id
  end
end
