class CreateCaseParties < ActiveRecord::Migration[6.0]
  def change
    create_table :case_parties do |t|
      t.references :case, null: false, foreign_key: true
      t.references :party, null: false, foreign_key: true

      t.timestamps
    end
    add_index :case_parties, [:case_id, :party_id], unique: true
  end
end
