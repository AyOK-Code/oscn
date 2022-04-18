class Title < ApplicationRecord
  validates :code, :name, presence: true
end
