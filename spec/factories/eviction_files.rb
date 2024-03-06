FactoryBot.define do
  factory :eviction_file do
    generated_at { '2024-02-15 15:53:29' }
    sent_at { '2024-02-15 15:53:29' }

    trait :with_file do
      after(:build) do |eviction_file|
        eviction_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'eviction-letters.csv')), filename: 'eviction-letters.csv', content_type: 'application/csv')
      end
    end
  end
end
