class OkSos::NameStatus < ApplicationRecord
  has_many :names, class_name: 'OkSos::Name'

  validates :name_status_id, :description, presence: true
end
