class CaseType < ApplicationRecord
  validates :name, :oscn_id, :abbreviation, presence: true
end
