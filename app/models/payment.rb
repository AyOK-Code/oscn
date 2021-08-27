# View of all amount owed, payments, adjustments by case and party
class Payment < ApplicationRecord
  belongs_to :court_case
  belongs_to :party

  def readonly?
    true
  end
end
