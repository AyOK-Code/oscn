class UpdateCaseStatsToVersion5 < ActiveRecord::Migration[6.1]
  def change
    update_view :case_stats, version: 5, revert_to_version: 4, materialized: true
  end
end
