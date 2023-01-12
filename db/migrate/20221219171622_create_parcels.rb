class CreateParcels < ActiveRecord::Migration[6.0]
  def change
    create_table :parcels do |t|
      t.string :geoid20,null:false
      t.string :zip 
      t.integer :tract, null:false
      t.string :block, null:false
      t.string :lat, null:true
      t.string :long, null:true

      t.timestamps

  
    end
    change_column_default :parcels, :created_at, from: nil, to: ->{ 'current_timestamp' }
    change_column_default :parcels, :updated_at, from: nil, to: ->{ 'current_timestamp' }
  end
end
