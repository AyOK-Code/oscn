class CreateDocAliases < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_aliases do |t|
      t.references :doc_profile, null: false, foreign_key: true
      t.integer :doc_number
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix

      t.timestamps
    end
  end
end
