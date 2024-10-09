class CreateReportCriminalCases < ActiveRecord::Migration[7.0]
  def change
    create_view :report_criminal_cases, materialized: true

    add_index :report_criminal_cases, :count_offense_on
    add_index :report_criminal_cases, :count_code_as_filed
    add_index :report_criminal_cases, :count_code_as_disposed
    add_index :report_criminal_cases, :count_disposition_on
    add_index :report_criminal_cases, :court_case_id
    add_index :report_criminal_cases, :county_id
    add_index :report_criminal_cases, :court_case_filed_on
    add_index :report_criminal_cases, :court_case_closed_on
  end
end
