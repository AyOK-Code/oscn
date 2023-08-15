class AddIsTooManyRecordsToScrapeJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :ok2_explore_scrape_jobs, :is_too_many_records, :boolean, null: false, default: false
  end
end
