class CreateDocOffenseCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_offense_codes do |t|
      t.string :statute_code
      t.string :description
      t.boolean :is_violent

      t.timestamps
    end
  end
end
