class OkcBlotter::Pdf < ApplicationRecord
  has_many :booking, dependent: :destroy
end
