class OkRealEstate::RegistrationRecord < ApplicationRecord
  belongs_to :agent, class_name: 'OkRealEstate::Agent'

  validates :external_id, presence: true
end
