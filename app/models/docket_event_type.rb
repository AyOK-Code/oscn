class DocketEventType < ApplicationRecord
  has_many :docket_events, dependent: :destroy
end
