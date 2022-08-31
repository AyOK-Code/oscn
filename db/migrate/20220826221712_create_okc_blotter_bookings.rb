class CreateOkcBlotterBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :pdfs, null: false, foreign_key: true
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
