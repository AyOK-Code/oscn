class AddDateFieldsToEvictionFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :eviction_files, :generated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
