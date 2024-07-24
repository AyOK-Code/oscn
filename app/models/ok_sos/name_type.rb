class OkSos::NameType < ApplicationRecord
  has_many :names, class_name: 'OkSos::Name'

  validates :name_type_id, :name_description, presence: true
end
