class AddMetadataToEvictionLetters < ActiveRecord::Migration[7.0]
  def change
    add_column :eviction_letters, :is_metadata_present, :boolean, null: false, default: false
    add_column :eviction_letters, :is_po_box, :boolean, null: false, default: false
    add_column :eviction_letters, :is_business, :boolean, null: false, default: false
    add_column :eviction_letters, :is_residential, :boolean, null: false, default: false
  end
end
