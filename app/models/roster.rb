class Roster < ApplicationRecord
  has_many :bookings, class_name: 'OkcBlotter::Booking'
  has_many :inmates, class_name: 'TulsaBlotter::Inmate'

  has_many :case_parties
  has_many :doc_profiles, class_name: 'Doc::Profile'
end
