class OkcBlotter::Booking < ApplicationRecord
  belongs_to :offense, class_name: 'OkcBlotter::Offense', foreign_key: 'offense_id'
  validates  :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
