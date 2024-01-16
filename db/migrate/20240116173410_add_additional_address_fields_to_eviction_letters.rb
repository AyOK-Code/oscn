class AddAdditionalAddressFieldsToEvictionLetters < ActiveRecord::Migration[7.0]
  def change
    add_column :eviction_letters, :validation_city, :string
    add_column :eviction_letters, :validation_zip_code, :string
    add_column :eviction_letters, :validation_state, :string
  end
end
