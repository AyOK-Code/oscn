class County < ApplicationRecord
  has_many :court_cases, dependent: :destroy

  validates :name, :fips_code, presence: true
end
