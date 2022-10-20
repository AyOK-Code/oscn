class Osco::Warrant < ApplicationRecord
    validates :first_name, :last_name,:birth_date,:case_number, presence: true
end
