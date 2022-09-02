class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf', foreign_key: 'pdfs_id'
  validates  :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
