class TulsaBlotter::Arrest < ApplicationRecord
  belongs_to :inmate, optional: true
  has_many :offenses,class_name: 'TulsaBlotter::Offense', foreign_key: 'arrest_id'
  validates :arrest_date, :arrest_time, :arrested_by, presence: true
end
