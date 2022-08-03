class County < ApplicationRecord
  has_many :court_cases, dependent: :destroy
  belongs_to :district_attorneys, optional: true

  validates :name, :fips_code, presence: true
end
