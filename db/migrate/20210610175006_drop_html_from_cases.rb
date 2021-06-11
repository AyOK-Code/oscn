class DropHtmlFromCases < ActiveRecord::Migration[6.0]
  def change
    remove_column :court_cases, :html, :text
    remove_column :court_cases, :scraped_at, :datetime
  end
end
