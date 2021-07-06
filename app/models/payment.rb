class Payment < ApplicationRecord
  belongs_to :court_case
  belongs_to :party

  def readonly?
    true
  end
end
