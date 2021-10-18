FactoryBot.define do
  factory :tax_intercept_event, parent: :docket_event do
    docket_event_type { DocketEventType.find_by(code: 'CTRS') || create(:docket_event_type, :tax_intercepted) }
  end
end
