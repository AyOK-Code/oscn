class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :case, null: false, foreign_key: true
      t.references :party, foreign_key: true
      t.date :event_at, null: false
      t.string :event_type
      t.string :docket

      t.timestamps
    end
  end
end
