class OkAssessor::Account < ApplicationRecord
  validate :account_num
end
