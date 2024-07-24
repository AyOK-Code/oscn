class OkSos::Suffix < ApplicationRecord
  has_many :officers, class_name: 'OkSos::Officer'

  validates :suffix_id, :suffix, presence: true
end
