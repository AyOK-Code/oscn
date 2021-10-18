class UpdateReportWarrantsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :report_warrants, version: 2, revert_to_version: 1, materialized: true
  end
end
