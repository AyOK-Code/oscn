class OklahomaStatute < ApplicationRecord
  validates :code, :ten_digit, :severity, :description, :effective_on, presence: true
end
