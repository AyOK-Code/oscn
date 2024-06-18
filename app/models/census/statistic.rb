class Census::Statistic < ApplicationRecord
  belongs_to :survey, class_name: 'Census::Survey'
  has_many :datas, class_name: 'Census::Data', dependent: :destroy

  validates :name, :label, :survey, :concept, :group, presence: true
end
