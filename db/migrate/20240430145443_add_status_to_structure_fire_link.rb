class AddStatusToStructureFireLink < ActiveRecord::Migration[7.0]
  def change
    add_column :structure_fire_links, :status, :integer, default: 0, null: false
  end
end
