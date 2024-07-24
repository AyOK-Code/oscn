class OkSos::FilingType < ApplicationRecord
  has_many :corp_filings, class_name: 'OkSos::CorpFiling', foreign_key: 'filing_type_id'

  validates :filing_type_id, :description, presence: true
end
