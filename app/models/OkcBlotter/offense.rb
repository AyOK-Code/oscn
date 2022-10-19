class OkcBlotter::Offense < ApplicationRecord
  belongs_to :booking, class_name: 'OkcBlotter::Booking', foreign_key: 'bookings_id'
  validates :type, :charge, presence: true
end
