class CaseType < ApplicationRecord
  has_many :court_cases, dependent: :destroy

  validates :name, :oscn_id, :abbreviation, presence: true
end
