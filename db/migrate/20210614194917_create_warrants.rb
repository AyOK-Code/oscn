class CreateWarrants < ActiveRecord::Migration[6.0]
  def change
    create_table :warrants do |t|
      t.references :docket_event, null: false, foreign_key: true
      t.references :judge, foreign_key: true
      t.integer :bond
      t.string :comment

      t.timestamps
    end
  end
end
