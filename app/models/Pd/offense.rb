class Pd::Offense < ApplicationRecord
  belongs_to :booking, class_name: 'Pd::Booking'
  has_many :offense_minutes, class_name: 'Pd::OffenseMinute', dependent: :destroy
  validates :offense_seq, presence: true
end
