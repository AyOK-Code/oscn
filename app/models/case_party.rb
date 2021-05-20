class CaseParty < ApplicationRecord
  belongs_to :case
  belongs_to :party
end
