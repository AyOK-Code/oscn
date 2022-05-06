FactoryBot.define do
  factory :docket_event_link do
    docket_event { nil }
    oscn_id { 1 }
    title { ['TIFF', 'PDF'].sample }
    link { Faker::Internet.url(host: 'oscn.net') }
  end
end
