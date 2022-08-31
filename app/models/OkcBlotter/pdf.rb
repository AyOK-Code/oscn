class OkcBlotter::Pdf < ApplicationRecord
  belongs_to :booking, class_name: 'OkcBlotter::Booking', foreign_key: 'booking_id'
end
