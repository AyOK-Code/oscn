class AddIndexToDocNumber < ActiveRecord::Migration[6.0]
  def change
    add_index :doc_profiles, :doc_number, unique: true
  end
end
