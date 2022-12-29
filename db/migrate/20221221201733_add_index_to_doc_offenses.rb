class AddIndexToDocOffenses < ActiveRecord::Migration[6.0]
  def change
    add_index :doc_offense_codes, [:statute_code, :description, :is_violent ],unique:true, name: 'doc_offense_codes_index'
  end
end
