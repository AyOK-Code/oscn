class OkRealEstate::Agent < ApplicationRecord
  has_many :places, class_name: 'OkRealEstate::Place', dependent: :destroy
  has_many :histories, class_name: 'OkRealEstate::History', dependent: :destroy

  validates :first_name, :last_name, :license_number, :license_expiration_on, presence: true
end
