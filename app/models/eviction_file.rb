class EvictionFile < ApplicationRecord
  has_many :eviction_letters, dependent: :nullify
  has_one_attached :file, dependent: :destroy
end
