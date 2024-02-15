class CreateEvictionFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :eviction_files do |t|
      t.datetime :sent_at

      t.timestamps
    end

    add_reference :eviction_letters, :eviction_file, foreign_key: true
  end
end
