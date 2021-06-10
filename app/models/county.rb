class County < ApplicationRecord
  validates :name, :fips_code, presence: true

  has_many :court_cases, dependent: :destroy
end
