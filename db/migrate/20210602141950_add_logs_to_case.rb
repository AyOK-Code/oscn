class AddLogsToCase < ActiveRecord::Migration[6.0]
  def change
    add_column :cases, :logs, :jsonb
  end
end
