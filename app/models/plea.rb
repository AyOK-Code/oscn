class Plea < ApplicationRecord
  has_many :counts

  validates :name, presence: true
end
