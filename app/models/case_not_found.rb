class CaseNotFound < ApplicationRecord
  belongs_to :county

  validates :case_number, presence: true
end
