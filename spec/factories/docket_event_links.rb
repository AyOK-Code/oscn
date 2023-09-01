FactoryBot.define do
  factory :docket_event_link do
    docket_event
    sequence(:oscn_id)
    title { ['TIFF', 'PDF'].sample }
    link { Faker::Internet.url(host: 'oscn.net') }

    trait :with_file do
      document { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')) }
    end
  end
end
