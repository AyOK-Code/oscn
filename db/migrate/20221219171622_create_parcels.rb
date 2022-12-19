class CreateParcels < ActiveRecord::Migration[6.0]
  def change
    create_table :parcels do |t|
      t.string :geoid20,null:false
      t.string :zip ,null:false
      t.integer :tract ,null:false
      t.string :block ,null:false
      t.decimal :lat, null:true
      t.decimal :long , null:true

      t.timestamps
    end
  end
end
