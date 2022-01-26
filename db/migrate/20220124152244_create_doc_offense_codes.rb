class CreateDocOffenseCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_offense_codes do |t|
      t.string :statute_code, null: false
      t.string :description, null: false
      t.boolean :is_violent, null: false, default: false

      t.timestamps
    end
  end
end
