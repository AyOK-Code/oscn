class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf', foreign_key: 'pdfs_id'
  has_many :offense, dependent: :destroy, foreign_key: 'bookings_id'
  validates  :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
