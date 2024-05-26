class Census::Data < ApplicationRecord
  belongs_to :statistic, class_name: 'Census:Statistic'
  belongs_to :area, polymorphic: true
  validates :name, :label, :survey, :concept, :group, presence: true
end
