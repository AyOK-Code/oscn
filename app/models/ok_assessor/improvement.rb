class OkAssessor::Improvement < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
  has_many :improvement_details, class_name: 'OkAssessor::ImprovementDetail'
end
