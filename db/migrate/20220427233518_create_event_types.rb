class CreateEventTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :event_types do |t|
      t.integer :oscn_id, null: false, index: { unique: true }
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
