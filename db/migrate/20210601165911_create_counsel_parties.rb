class CreateCounselParties < ActiveRecord::Migration[6.0]
  def change
    create_table :counsel_parties do |t|
      t.references :case, null: false, foreign_key: true
      t.references :party, null: false, foreign_key: true
      t.references :counsel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
