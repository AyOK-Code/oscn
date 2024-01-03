class OkRealEstate::AgentPlace < ApplicationRecord
  belongs_to :agent, class_name: 'OkRealEstate::Agent'
  belongs_to :places, class_name: 'OkRealEstate::Place'
end
