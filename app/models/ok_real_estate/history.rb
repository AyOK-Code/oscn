class OkRealEstate::History < ApplicationRecord
  belongs_to :agent, class_name: 'OkRealEstate::Agent'
end
