class OkSos::CorpFiling < ApplicationRecord
  belongs_to :filing_type, class_name: 'OkSos::FilingType', optional: true
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true

  validates :filing_number, :document_number, presence: true
end
