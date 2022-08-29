class OkcBlotterBooking < ApplicationRecord
  validates :pdf_id, :person_id, :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
