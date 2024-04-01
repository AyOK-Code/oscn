class AddUniqueConstraintToEvictionLetters < ActiveRecord::Migration[7.0]
  def change
    remove_index :eviction_letters, :docket_event_link_id
    add_index :eviction_letters, :docket_event_link_id, unique: true
  end
end
