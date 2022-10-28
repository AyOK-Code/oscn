class RenameBlotterTables < ActiveRecord::Migration[6.0]
  def change
    rename_table :pdfs, :okc_blotter_pdfs
    rename_table :bookings, :okc_blotter_bookings
    rename_table :offenses, :okc_blotter_offenses

    rename_column(:okc_blotter_bookings, :pdfs_id, :pdf_id)
    rename_column(:okc_blotter_offenses, :bookings_id, :booking_id)

    change_column(:okc_blotter_bookings, :booking_date, :datetime)
    change_column(:okc_blotter_bookings, :release_date, :datetime)
    change_column(:okc_blotter_offenses, :bond, :decimal, precision: 10, scale: 2)
  end
end
