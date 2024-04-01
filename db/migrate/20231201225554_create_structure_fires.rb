class CreateStructureFires < ActiveRecord::Migration[7.0]
  def change
    create_table :structure_fires do |t|
      t.integer :incident_number, null: false
      t.string :incident_type, null: false
      t.string :station, null: false
      t.date :incident_date, null: false
      t.integer :street_number, null: false, default: ''
      t.string :street_prefix, null: false, default: ''
      t.string :street_name, null: false, default: ''
      t.string :street_type, null: false, default: ''
      t.decimal :property_value
      t.decimal :property_loss
      t.decimal :content_value
      t.decimal :content_loss
      t.references :structure_fire_link, null: false, foreign_key: true


      t.timestamps
    end
  end
end
