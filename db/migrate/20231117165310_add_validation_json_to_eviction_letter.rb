class AddValidationJsonToEvictionLetter < ActiveRecord::Migration[7.0]
  def change
    add_column :eviction_letters, :validation_object, :jsonb
  end
end
