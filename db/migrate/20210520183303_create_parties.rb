class CreateParties < ActiveRecord::Migration[6.0]
  def change
    create_table :parties do |t|
      t.integer :oscn_id, index: { unique: true }
      t.string :full_name
      t.references :party_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
