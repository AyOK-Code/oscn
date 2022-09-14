class OkcBlotter::Booking < ApplicationRecord
  belongs_to :pdf, class_name: 'OkcBlotter::Pdf'
  belongs_to :roster, optional: true
  has_many :offenses, dependent: :destroy
end
