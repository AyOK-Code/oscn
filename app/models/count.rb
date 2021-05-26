class Count < ApplicationRecord
  belongs_to :case
  belongs_to :party
  belongs_to :plea, optional: true
  belongs_to :verdict, optional: true
end
