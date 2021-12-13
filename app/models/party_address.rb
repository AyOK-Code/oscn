class PartyAddress < ApplicationRecord
  belongs_to :party

  scope :current, -> { where(status: 'Current') }
  # TODO: check what we can validate on this as we import data
end
