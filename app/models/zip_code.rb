class ZipCode < ApplicationRecord
  has_many :datas, class_name: 'Census::Data', as: :area, dependent: :destroy

  validates :name, presence: true
end
