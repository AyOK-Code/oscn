class Census::Survey < ApplicationRecord
  has_many :statistics, class_name: 'Census::Statistic', dependent: :destroy

  validates :name, :year, presence: true
end
