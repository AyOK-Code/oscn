class CreateStructureFires < ActiveRecord::Migration[7.0]
  def change
    create_table :structure_fires do |t|
      t.integer :incident_number
      t.string :incident_type
      t.string :station
      t.date :incident_date
      t.integer :street_number
      t.string :street_prefix
      t.string :street_name
      t.string :street_type
      t.decimal :property_value
      t.decimal :property_loss
      t.decimal :content_value
      t.decimal :content_loss
      t.references :structure_fire_link, null: false, foreign_key: true


      t.timestamps
    end
  end
end
