class OkcBlotterOffense < ApplicationRecord
  validates :booking_id, :type, :charge, presence: true
end
