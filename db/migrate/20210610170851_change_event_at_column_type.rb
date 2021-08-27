class ChangeEventAtColumnType < ActiveRecord::Migration[6.0]
  def up
    change_column :events, :event_at, :datetime
  end

  def down
    change_column :events, :event_at, :date
  end
end
