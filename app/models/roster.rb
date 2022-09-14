class Roster < ApplicationRecord
  has_many :bookings,class_name: 'OkcBlotter::Booking', foreign_key: 'roster_id'
  has_many :case_parties, foreign_key: 'roster_id'
  has_many :doc_profiles, class_name: 'Doc::Profile',foreign_key: 'roster_id'
end
