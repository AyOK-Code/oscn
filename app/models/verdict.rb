class Verdict < ApplicationRecord
  has_many :counts, dependent: :destroy

  validates :name, presence: true
end
