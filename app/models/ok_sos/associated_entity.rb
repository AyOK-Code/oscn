class OkSos::AssociatedEntity < ApplicationRecord
  belongs_to :capacity, class_name: 'OkSos::Capacity'
  belongs_to :corp_type, class_name: 'OkSos::CorpType', optional: true
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true

  validates :filing_number, presence: true
end
