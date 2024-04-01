class OkRealEstate::Agent < ApplicationRecord
  has_many :places, class_name: 'OkRealEstate::Place', dependent: :destroy
  has_many :histories, class_name: 'OkRealEstate::RegistrationHistory', dependent: :destroy
  has_one :record, class_name: 'OkRealEstate::RegistrationRecord', dependent: :destroy

  validates :first_name, :last_name, :license_number, :license_expiration_on, presence: true

  scope :needs_scrape, -> { where('scraped_on < ? OR scraped_on IS NULL', 1.month.ago) }
end
