class CreateOkcBlotterOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :okc_blotter_offenses do |t|
      t.integer :booking_id ,null:false
      t.string :type , null:false
      t.decimal :bond ,precision: 2
      t.string :code
      t.string :dispo 
      t.string :charge, null:false
      t.string :warrant_number
      t.string :citation_number

      t.timestamps
    end
  end
end
