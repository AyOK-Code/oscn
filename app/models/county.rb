class County < ApplicationRecord
  has_many :court_cases, dependent: :destroy
  belongs_to :district_attorney, optional: true

  validates :name, :fips_code, presence: true
end
