class Pd::Booking < ApplicationRecord
  has_many :offenses, class_name: 'Pd::Offense', dependent: :destroy
end
