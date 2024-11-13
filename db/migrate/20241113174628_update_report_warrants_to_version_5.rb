class UpdateReportWarrantsToVersion5 < ActiveRecord::Migration[7.0]
  def change
    drop_view :report_searchable_cases, materialized: true

    update_view :report_warrants,
      version: 5,
      revert_to_version: 4,
      materialized: true

    create_view :report_searchable_cases,
      version: 3,
      materialized: true
  end
end
