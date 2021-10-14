class UpdateCaseStatsToVersion4 < ActiveRecord::Migration[6.1]
  def change
    update_view :case_stats, materialized: true, version: 4
    add_index :case_stats, :court_case_id
  end
end
