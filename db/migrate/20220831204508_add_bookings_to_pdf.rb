class AddBookingsToPdf < ActiveRecord::Migration[6.0]
  def change
    add_reference :pdfs, :booking, null: false, foreign_key: true
    add_reference :bookings, :offense, null: false, foreign_key: true
    


  end
end
