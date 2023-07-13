class CreateCaseNotFounds < ActiveRecord::Migration[7.0]
  def change
    create_table :case_not_founds do |t|
      t.references :county, null: false, foreign_key: true
      t.string :case_number, null: false

      t.timestamps
    end
  end
end
