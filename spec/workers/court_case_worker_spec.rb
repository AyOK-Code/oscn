require 'rails_helper'

RSpec.describe CourtCaseWorker, type: :worker do
  describe '#perform' do
    let(:county) { create(:county, id: 55, name: 'Tulsa') }
    let!(:court_case) { create(:court_case, case_number: case_number, county: county) }
    let(:case_number) { 'CF-2018-1016' }

    it 'imports case HTML and court case data when scrape_case is true' do
      allow(::Importers::CaseHtml).to have_received(:perform)
      allow(::Importers::CourtCase).to have_received(:perform)
      expect(::Importers::CaseHtml).to have_received(:perform).with(county.id, case_number)
      expect(::Importers::CourtCase).to have_received(:perform).with(county.id, case_number)

      described_class.perform(county.id, case_number, true)
    end

    it 'does not import case HTML but imports court case data when scrape_case is false' do
      allow(::Importers::CaseHtml).to have_received(:perform)
      allow(::Importers::CourtCase).to have_received(:perform)
      expect(::Importers::CaseHtml).not_to have_received(:perform)
      expect(::Importers::CourtCase).to have_received(:perform).with(county.id, case_number)

      described_class.perform(county.id, case_number, false)
    end

    it 'updates court case status to not enqueued' do
      court_case.update(enqueued: true)
      allow(::Importers::CaseHtml).to have_received(:perform)
      allow(::Importers::CourtCase).to have_received(:perform)

      described_class.perform(county.id, case_number, true)
      expect(court_case.reload.enqueued).to be false
    end

    it 'is a Sidekiq worker' do
      expect(described_class).to include(Sidekiq::Worker)
    end

    it 'is a Sidekiq throttled worker' do
      expect(described_class).to include(Sidekiq::Throttled::Worker)
    end

    it 'has Sidekiq retry options set to 5' do
      expect(described_class.sidekiq_options['retry']).to eq(5)
    end

    it 'has Sidekiq queue set to :medium' do
      expect(described_class.sidekiq_options['queue']).to eq(:medium)
    end
  end
end
