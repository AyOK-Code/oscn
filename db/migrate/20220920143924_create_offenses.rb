class CreateOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_offenses do |t|
      t.references :arrest, null: true, foreign_key: true
      t.string :description
      t.string :case_number
      t.string :court_date
      t.string :bond_type
      t.string :bound_amount
      t.string :disposition

      t.timestamps
    end
  end
end
