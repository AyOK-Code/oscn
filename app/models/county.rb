class County < ApplicationRecord
  validates :name, :fips_code, presence: true

  has_many :cases, dependent: :destroy
end
