class CreateOkcBlotterBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :okc_blotter_bookings do |t|
      t.integer :pdf_id, null:false
      t.integer :person_id, null:false
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :sex
      t.string :race
      t.string :zip
      t.boolean :transient, null:false, default:false
      t.string :inmate_number,null:false
      t.string :booking_number,null:false
      t.string :booking_type
      t.date :booking_date , null:false
      t.date :release_date

      t.timestamps
    end
  end
end
