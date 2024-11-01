class OkAssessor::Account < ApplicationRecord
  has_many :improvements, class_name: 'OkAssessor::Improvement', dependent: :destroy
  has_many :land_attributes, class_name: 'OkAssessor::LandAttribute', dependent: :destroy
  has_many :sales, class_name: 'OkAssessor::Sale', dependent: :destroy
  has_many :value_details, class_name: 'OkAssessor::ValueDetail', dependent: :destroy

  has_one :owner, class_name: 'OkAssessor::Owner', dependent: :destroy
  has_one :section_township_range, class_name: 'OkAssessor::SectionTownshipRange', dependent: :destroy

  validate :account_num
end
