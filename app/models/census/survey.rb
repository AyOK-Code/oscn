class Census::Survey < ApplicationRecord
  ACS1 = 'acs1'
  ACS5 = 'acs5'

  has_many :statistics, class_name: 'Census::Statistic', dependent: :destroy

  validates :name, :year, presence: true
end
