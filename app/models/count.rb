class Count < ApplicationRecord
  belongs_to :court_case
  belongs_to :party
  belongs_to :plea, optional: true
  belongs_to :verdict, optional: true
end
