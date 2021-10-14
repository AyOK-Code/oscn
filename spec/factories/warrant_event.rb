FactoryBot.define do
  factory :warrant_event, parent: :docket_event do
    docket_event_type { DocketEventType.find_by(code: DocketEventType::WARRANT_CODES) || create(:docket_event_type, :warrant_issued) }
  end
end
