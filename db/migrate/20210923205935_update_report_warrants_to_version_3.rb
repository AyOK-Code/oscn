class UpdateReportWarrantsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :report_warrants, version: 3, revert_to_version: 2, materialized: true
  end
end
