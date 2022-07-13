FactoryBot.define do
  factory :docket_event_link do
    docket_event
    sequence(:oscn_id)
    title { ['TIFF', 'PDF'].sample }
    link { Faker::Internet.url(host: 'oscn.net') }
  end
end
