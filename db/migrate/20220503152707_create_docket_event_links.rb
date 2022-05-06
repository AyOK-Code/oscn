class CreateDocketEventLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :docket_event_links do |t|
      t.references :docket_event, null: false, foreign_key: true
      t.integer :oscn_id ,null: false
      t.string :title,null: false
      t.string :link,null: false

      t.timestamps
    end
  end
end
