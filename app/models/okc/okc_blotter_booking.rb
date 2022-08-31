class Okc::OkcBlotterBooking < ApplicationRecord
  belongs_to :okc_offense, class_name: 'Okc::OkcBlotterOffense', foreign_key: 'okc_blotter_offense_id'
  validates  :transient, :inmate_number, :booking_number, :booking_date, presence: true
end
