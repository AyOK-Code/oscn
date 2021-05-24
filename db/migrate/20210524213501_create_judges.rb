class CreateJudges < ActiveRecord::Migration[6.0]
  def change
    create_table :judges do |t|
      t.string :name, null: false
      t.string :courthouse
      t.string :judge_type, null: false
      t.references :county, null: false, foreign_key: true

      t.timestamps
    end
  end
end
