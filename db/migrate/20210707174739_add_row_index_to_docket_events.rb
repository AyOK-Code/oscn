class AddRowIndexToDocketEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :docket_events, :row_index, :integer, null: false
  end
end
