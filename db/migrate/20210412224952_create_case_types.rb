class CreateCaseTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :case_types do |t|
      t.integer :oscn_id, null: false
      t.string :name, null: false
      t.string :abbreviation, null: false

      t.timestamps
    end
  end
end
