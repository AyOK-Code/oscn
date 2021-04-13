class CaseType < ApplicationRecord
  validates :name, :oscn_id, :abbreviation, presence: true

  has_many :cases, dependent: :destroy
end
