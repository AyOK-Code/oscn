class DocketEvent < ApplicationRecord
  belongs_to :case
  belongs_to :docket_event_type
  belongs_to :party, optional: true
end
