class CaseType < ApplicationRecord
  has_many :court_cases, dependent: :destroy

  validates :name, :oscn_id, :abbreviation, presence: true

  scope :active, -> { where(abbreviation: CASE_TYPES).pluck(:oscn_id) }
  scope :oscn_id_mapping, -> { where(abbreviation: CASE_TYPES).pluck(:abbreviation, :id).to_h }
end
