class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf'
  belongs_to :roster, optional: true
  has_many :offenses, class_name: 'OkcBlotter::Offense', dependent: :destroy
end
