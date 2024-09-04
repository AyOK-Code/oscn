class OkAssessor::Sale < ApplicationRecord
  belongs_to :account, class_name: 'OkAssessor::Account'
end
