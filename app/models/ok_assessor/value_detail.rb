class OkAssessor::ValueDetail < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
end
