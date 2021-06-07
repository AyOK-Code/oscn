class CreateDocketEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :docket_events do |t|
      t.references :case, null: false, foreign_key: true
      t.date :event_on
      t.references :docket_event_type, null: false, foreign_key: true
      t.text :description
      t.decimal :amount

      t.timestamps
    end
  end
end
