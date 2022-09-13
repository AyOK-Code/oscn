class CaseParty < ApplicationRecord
  belongs_to :roster, class_name: 'Roster', foreign_key: 'roster_id', optional: true
  belongs_to :court_case
  belongs_to :party

  validates :party_id, uniqueness: { scope: :court_case_id, case_sensitive: true }
end
