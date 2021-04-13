class CreateCases < ActiveRecord::Migration[6.0]
  def change
    create_table :cases do |t|
      t.integer :oscn_id
      t.references :county, null: false, foreign_key: true
      t.references :case_type, null: false, foreign_key: true
      t.string :case_number
      t.date :filed_on
      t.date :closed_on
      t.text :html

      t.timestamps
    end
  end
end
