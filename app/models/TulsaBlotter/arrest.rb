class TulsaBlotter::Arrest < ApplicationRecord
  belongs_to :inmate, optional: true
  has_many :tulsa_offenses, foreign_key: 'arrest_id'
  validates :arrest_date, :arrest_time, :arrested_by, presence: true
end
