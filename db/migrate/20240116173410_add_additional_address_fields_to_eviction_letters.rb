class AddAdditionalAddressFieldsToEvictionLetters < ActiveRecord::Migration[7.0]
  def change
    add_column :eviction_letters, :validation_city, :string, null: false, default: ''
    add_column :eviction_letters, :validation_zip_code, :string, null: false, default: ''
    add_column :eviction_letters, :validation_state, :string, null: false, default: ''
  end
end
