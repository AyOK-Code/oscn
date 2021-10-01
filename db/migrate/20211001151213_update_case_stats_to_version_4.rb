class UpdateCaseStatsToVersion4 < ActiveRecord::Migration[6.1]
  def change
    drop_view :case_stats, revert_to_version: 3
    create_view :case_stats, materialized: true, version: 4
    add_index :case_stats, :court_case_id
  end
end
