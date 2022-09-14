class OkcBlotter::Pdf < ApplicationRecord
  has_many :bookings, dependent: :destroy
end
