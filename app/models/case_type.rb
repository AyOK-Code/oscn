class CaseType < ApplicationRecord
  validates :name, :oscn_id, :abbreviation, presence: true

  has_many :court_cases, dependent: :destroy
end
