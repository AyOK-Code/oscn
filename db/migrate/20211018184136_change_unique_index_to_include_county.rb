class ChangeUniqueIndexToIncludeCounty < ActiveRecord::Migration[6.0]
  def change
    remove_index :court_cases, :oscn_id
    add_index :court_cases, [:county_id, :oscn_id], unique: true
  end
end
