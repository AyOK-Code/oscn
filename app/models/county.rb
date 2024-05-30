class County < ApplicationRecord
  OKLAHOMA = 'Oklahoma'
  TULSA = 'Tulsa'

  has_many :court_cases, dependent: :destroy
  has_many :case_not_founds, dependent: :destroy
  has_many :datas, class_name: 'Census::Data', as: :area, dependent: :destroy
  belongs_to :district_attorney, optional: true

  validates :name, :fips_code, presence: true

  def self.name_id_mapping
    pluck(:name, :id).to_h
  end
end
