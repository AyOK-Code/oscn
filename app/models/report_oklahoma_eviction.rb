class ReportOklahomaEviction < ApplicationRecord
  belongs_to :court_case

  scope :filed_year, ->(year) { where(case_filed_on: Date.new(year.to_i - 1, 12, 31)..Date.new(year.to_i, 12, 31)) }
  scope :recent_evictions, -> { where(case_filed_on: 4.days.ago..1.day.from_now) }

  def self.refresh
    Scenic.database.refresh_materialized_view(:report_oklahoma_evictions, concurrently: true, cascade: false)
  end

  def docket_link_id
    docket_event_type_id = DocketEventType.find_by(code: 'P').id
    docket = court_case.docket_events.where(docket_event_type_id: docket_event_type_id).first
    return nil if docket.nil?

    pdf = docket.links.pdf.first
    return nil if pdf.nil?

    pdf.id
  end

  def readonly?
    true
  end
end
