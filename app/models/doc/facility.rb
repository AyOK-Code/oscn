class Doc::Facility < ApplicationRecord
  validates :name,  presence: true
end
