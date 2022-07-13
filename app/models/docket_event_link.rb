class DocketEventLink < ApplicationRecord
  belongs_to :docket_event
  validates :oscn_id, :title, :link, presence: true
end