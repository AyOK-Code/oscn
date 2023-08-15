class CreateOk2ExploreScrapeJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :ok2_explore_scrape_jobs do |t|
      t.integer :year, null: false
      t.integer :month, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :is_success, null: false, default: false

      t.timestamps
    end
  end
end
