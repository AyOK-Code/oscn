class Warrant < ApplicationRecord
  belongs_to :docket_event
  belongs_to :judge, optional: true
end
