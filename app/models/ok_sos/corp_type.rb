class OkSos::CorpType < ApplicationRecord
  has_many :associated_entities, class_name: 'OkSos::AssociatedEntity'
  has_many :entities, class_name: 'OkSos::Entity'

  validates :corp_type_id, :corp_type_description, presence: true
end
