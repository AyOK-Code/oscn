class Counsel < ApplicationRecord
  has_many :counsel_parties, dependent: :destroy
  has_many :parties, through: :counsel_parties
  # TODO: Conditionally require more information for the data ok_bar: true rows
  # TODO: Add unique constraint on bar_number
  validates :bar_number, uniqueness: true, if: :has_bar_number?

  def has_bar_number?
    bar_number.present?
  end
end
