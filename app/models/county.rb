class County < ApplicationRecord
  validates :name, :fips_code, presence: true
end
