class CounselParty < ApplicationRecord
  belongs_to :court_case
  belongs_to :party
  belongs_to :counsel
end
