class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.integer :number
      t.string :name
      t.references :court_case, null: false, foreign_key: true
      t.references :count_code, null: false, foreign_key: true
      t.references :filed_by, null: false, foreign_key: { to_table: :parties }
      t.date :filed_on

      t.timestamps
    end
  end
end
