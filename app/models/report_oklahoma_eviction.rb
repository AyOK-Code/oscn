class ReportOklahomaEviction < ApplicationRecord
  belongs_to :court_case

  scope :filed_year, ->(year) { where(case_filed_on: Date.new(year.to_i - 1, 12, 31)..Date.new(year.to_i, 12, 31)) }

  def docket_link_id
    docket_event_type_id = DocketEventType.find_by(code: 'P').id
    docket = court_case.docket_events.where(docket_event_type_id: docket_event_type_id).first
    return nil if docket.nil?

    docket.links.pdf.first.id
  end

  def readonly?
    true
  end
end
