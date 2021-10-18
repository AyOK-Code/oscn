class UpdateCaseStatsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    drop_view :case_stats
    create_view :case_stats, version: 3, materialized: true
  end
end
