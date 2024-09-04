class AddNameIndexToZipCode < ActiveRecord::Migration[7.0]
  def change
    add_index :zip_codes, :name, unique: true
  end
end
