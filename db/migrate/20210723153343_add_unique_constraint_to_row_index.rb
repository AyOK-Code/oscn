class AddUniqueConstraintToRowIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :docket_events, [:row_index, :court_case_id], unique: true
  end
end
