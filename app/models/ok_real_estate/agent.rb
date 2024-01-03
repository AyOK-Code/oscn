class OkRealEstate::Agent < ApplicationRecord
  has_many :agent_places, class_name: 'OkRealEstate::AgentPlace', dependent: :destroy
  has_many :places, through: :agent_places, class_name: 'OkRealEstate::Place'
  has_many :histories, class_name: 'OkRealEstate::RegistrationHistory', dependent: :destroy
  has_one :record, class_name: 'OkRealEstate::RegistrationRecord', dependent: :destroy

  validates :first_name, :last_name, :license_number, :license_expiration_on, presence: true

  scope :needs_scrape, -> { where(scraped_on: 1.month.ago).or(where(scraped_on: nil)) }
end
