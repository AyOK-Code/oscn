class OkSos::Entity < ApplicationRecord
  belongs_to :corp_type, class_name: 'OkSos::CorpType'
  belongs_to :corp_status, class_name: 'OkSos::CorpStatus', foreign_key: 'status_id', primary_key: 'status_id',
                           optional: true
  belongs_to :entity_address, class_name: 'OkSos::EntityAddress', optional: true
  has_many :names, class_name: 'OkSos::Name'
  has_many :officers, class_name: 'OkSos::Officer'
  has_many :agents, class_name: 'OkSos::Agent'
  has_many :associated_entities, class_name: 'OkSos::AssociatedEntity'
  has_many :corp_filings, class_name: 'OkSos::CorpFiling'
  has_many :stock_datas, class_name: 'OkSos::StockData'
  has_many :stock_infos, class_name: 'OkSos::StockInfo'
end
