class Verdict < ApplicationRecord
  has_many :counts, dependent: :destroy
  has_many :issue_parties, dependent: :destroy
  has_many :issues, through: :issue_parties

  validates :name, presence: true, uniqueness: true
end
