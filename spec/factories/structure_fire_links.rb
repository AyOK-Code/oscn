FactoryBot.define do
  factory :structure_fire_link do
    url { 'https://www.okc.gov/faker/showpublisheddocument/36386/638245780010170000' }
    date { '2023-12-01' }
    pdf { nil }

    trait :with_file do
      pdf { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'july_10th.pdf')) }
    end
  end
end
