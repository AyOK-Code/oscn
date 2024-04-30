FactoryBot.define do
  factory :structure_fire_link do
    external_url { 'https://www.okc.gov/faker/showpublisheddocument/36386/638245780010170000' }
    pdf_date_on { '2023-12-01' }
    pdf { nil }

    trait :with_file do
      pdf { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'july_10th.pdf')) }
    end
  end
end
