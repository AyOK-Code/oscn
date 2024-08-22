class OkAssessor::ImprovementDetail < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
end
