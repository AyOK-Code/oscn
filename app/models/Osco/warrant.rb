class Osco::Warrant < ApplicationRecord
  validates :case_number, presence: true
end
