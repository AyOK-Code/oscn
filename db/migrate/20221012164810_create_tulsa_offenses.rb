class CreateTulsaOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_offenses do |t|
      t.string :description
      t.string :case_number, null: true
      t.string :court_date, null: true
      t.string :bond_type, null: true
      t.string :bound_amount, null: true
      t.string :disposition, null: true
      t.timestamps


    end
  end
end
