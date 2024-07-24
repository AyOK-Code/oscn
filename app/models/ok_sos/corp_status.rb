class OkSos::CorpStatus < ApplicationRecord
  # TODO: Change to use internal id
  has_many :entities, class_name: 'OkSos::Entity', foreign_key: 'status_id', primary_key: 'status_id'

  validates :status_id, :status_description, presence: true
end
