class CreateCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :counts do |t|
      t.references :case, null: false, foreign_key: true
      t.references :party, null: false, foreign_key: true
      t.date :offense_on
      t.string :as_filed
      t.string :filed_statute_violation
      t.string :disposition
      t.date :disposition_on
      t.string :disposed_statute_violation
      t.references :plea, foreign_key: true
      t.references :verdict, foreign_key: true

      t.timestamps
    end
  end
end
