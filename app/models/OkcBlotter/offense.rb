class OkcBlotter::Offense < ApplicationRecord
  validates :type, :charge, presence: true
end
