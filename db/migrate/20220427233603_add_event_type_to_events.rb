class AddEventTypeToEvents < ActiveRecord::Migration[6.0]
  def change
    rename_column :events, :event_type, :event_name
    add_reference :events, :event_type, foreign_key: true
  end
end
