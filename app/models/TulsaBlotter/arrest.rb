class TulsaBlotter::Arrest < ApplicationRecord
  belongs_to :inmate, foreign_key: 'tulsa_blotter_inmates_id'
  has_many :offenses, class_name: 'TulsaBlotter::Offense', foreign_key: 'tulsa_blotter_arrests_id'
  validates :arrest_date, :arrest_time, :arrested_by, presence: true
end
