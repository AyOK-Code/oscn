class TulsaBlotter::Offense < ApplicationRecord
  belongs_to :arrest, foreign_key: 'tulsa_blotter_arrests_id'
  validates :description, presence: true
end
