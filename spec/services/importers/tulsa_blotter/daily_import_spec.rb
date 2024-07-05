require 'rails_helper'

RSpec.describe Importers::TulsaBlotter::DailyImport do
  describe '#perform' do
    before do
      ENV['AWS_LAMBDA_REGION'] = 'us-east-2'
    end
    context 'when blotter data exists' do
      it 'imports the data' do
        VCR.use_cassette 'tulsa_blotter_shortened' do
          Importers::TulsaBlotter::DailyImport.perform # NOTE: vcr has been shortened
        end

        expect(TulsaBlotter::PageHtml.count).to be > 0
        expect(TulsaBlotter::Arrest.count).to be > 0
        expect(TulsaBlotter::ArrestDetailsHtml.count).to be > 0
        expect(TulsaBlotter::Offense.count).to be > 0
      end
    end

    context 'when doing another import' do
      before do
        VCR.use_cassette 'tulsa_blotter_shortened' do
          Importers::TulsaBlotter::DailyImport.perform
        end
      end

      it 'creates new pages' do
        page_html_count = TulsaBlotter::PageHtml.count
        VCR.use_cassette 'tulsa_blotter_shortened' do
          Importers::TulsaBlotter::DailyImport.perform
        end
        expect(TulsaBlotter::PageHtml.count).to be page_html_count * 2
      end

      it 'updates all data that was already present without creating new records' do
        arrest_count = TulsaBlotter::Arrest.count
        arrest_detail_count = TulsaBlotter::ArrestDetailsHtml.count
        offense_count = TulsaBlotter::Offense.count

        VCR.use_cassette 'tulsa_blotter_shortened' do
          Importers::TulsaBlotter::DailyImport.perform
        end

        expect(TulsaBlotter::Arrest.count).to be arrest_count
        expect(TulsaBlotter::ArrestDetailsHtml.count).to be arrest_detail_count
        expect(TulsaBlotter::Offense.count).to be offense_count
      end
    end

    context "when there are un-released inmates who aren't on daily import" do
      let!(:arrest) { create(:tulsa_blotter_arrest, release_date: nil) }
      it 'flags them as released' do
        VCR.use_cassette 'tulsa_blotter_shortened' do
          Importers::TulsaBlotter::DailyImport.perform
        end

        expect(arrest.reload.freedom_date).not_to eq nil
      end
    end
  end
end
