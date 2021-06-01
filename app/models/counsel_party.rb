class CounselParty < ApplicationRecord
  belongs_to :case
  belongs_to :party
  belongs_to :counsel
end
