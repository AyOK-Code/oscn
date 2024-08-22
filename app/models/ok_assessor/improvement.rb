class OkAssessor::Improvement < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
end
