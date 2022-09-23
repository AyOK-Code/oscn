class AddRosterRefToBookings < ActiveRecord::Migration[6.0]
  def change
    add_reference :bookings, :roster, null: true, foreign_key: true
    add_reference :case_parties, :roster, null: true, foreign_key: true
    add_reference :doc_profiles, :roster, null: true, foreign_key: true
  end
end
