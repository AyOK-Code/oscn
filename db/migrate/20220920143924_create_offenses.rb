class CreateOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_tulsa_offenses do |t|
      t.references :tulsa_blotter_arrests, null: true, foreign_key: true
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
