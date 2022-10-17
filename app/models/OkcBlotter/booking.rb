class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf', foreign_key: 'pdf_id'
  belongs_to :roster, optional: true
  has_many :offense, dependent: :destroy, foreign_key: 'booking_id'
  validates :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
