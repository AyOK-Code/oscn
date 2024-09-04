class OkAssessor::ImprovementDetail < ApplicationRecord
  belongs_to :improvement, class_name: 'OkAssessor::Improvement'
end
