class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf'
  has_many :offense, dependent: :destroy
  validates :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
