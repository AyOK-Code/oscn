class CaseParty < ApplicationRecord
  belongs_to :court_case
  belongs_to :party
end
