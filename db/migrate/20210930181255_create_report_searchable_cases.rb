class CreateReportSearchableCases < ActiveRecord::Migration[6.1]
  def change
    create_view :report_searchable_cases, materialized: true
    add_index :report_searchable_cases, :filed_on
    add_index :report_searchable_cases, :case_number
    add_index :report_searchable_cases, :first_name
    add_index :report_searchable_cases, :last_name
  end
end
