class UpdateReportSearchableCasesToVersion2 < ActiveRecord::Migration[6.1]
  def change
    # index first to make generating view faster
    add_index :report_warrants, [:party_id, :code]
    update_view :report_searchable_cases, version: 2, revert_to_version: 1, materialized: true
  end
end
