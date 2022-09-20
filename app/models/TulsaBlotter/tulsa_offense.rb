class TulsaBlotter::TulsaOffense < ApplicationRecord
  belongs_to :arrest, optional: true
  validates :case_number, :court_date, :bond_type, :disposition, presence: true
end
