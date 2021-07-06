class PartyAddress < ApplicationRecord
  belongs_to :party

  # TODO: check what we can validate on this as we import data
end
