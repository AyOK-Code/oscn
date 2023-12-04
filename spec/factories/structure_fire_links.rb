FactoryBot.define do
  factory :structure_fire_link do
    url { "MyString" }
    date { "2023-12-01" }
    pdf { nil }

    trait :with_file do
      document { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'july_10th.pdf')) }
    end
  end
end
