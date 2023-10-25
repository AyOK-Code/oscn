class IssueParty < ApplicationRecord
  belongs_to :issue
  belongs_to :party
  belongs_to :verdict, optional: true
end
