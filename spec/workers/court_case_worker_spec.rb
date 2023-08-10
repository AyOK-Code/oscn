require 'rails_helper'

RSpec.describe CourtCaseWorker, type: :worker do
  describe '#perform' do
    let(:county) { create(:county, id: 55, name: 'Tulsa') }
    let!(:court_case) { create(:court_case, case_number: case_number, county: county) }
    let(:case_number) { 'CF-2018-1016' }

    it 'imports case HTML and court case data when scrape_case is true' do
      allow(::Importers::CaseHtml).to receive(:perform)
      allow(::Importers::CourtCase).to receive(:perform)
      expect(::Importers::CaseHtml).to receive(:perform).with(county.id, case_number)
      expect(::Importers::CourtCase).to receive(:perform).with(county.id, case_number)

      subject.perform(county.id, case_number, true)
    end

    it 'does not import case HTML but imports court case data when scrape_case is false' do
      allow(::Importers::CaseHtml).to receive(:perform)
      allow(::Importers::CourtCase).to receive(:perform)
      expect(::Importers::CaseHtml).not_to receive(:perform)
      expect(::Importers::CourtCase).to receive(:perform).with(county.id, case_number)

      subject.perform(county.id, case_number, false)
    end

    it 'updates court case status to not enqueued' do
      court_case.update(enqueued: true)
      allow(::Importers::CaseHtml).to receive(:perform)
      allow(::Importers::CourtCase).to receive(:perform)

      subject.perform(county.id, case_number, true)
      expect(court_case.reload.enqueued).to be false
    end

    it 'is a Sidekiq worker' do
      expect(CourtCaseWorker).to include(Sidekiq::Worker)
    end

    it 'is a Sidekiq throttled worker' do
      expect(CourtCaseWorker).to include(Sidekiq::Throttled::Worker)
    end

    it 'has Sidekiq retry options set to 5' do
      expect(CourtCaseWorker.sidekiq_options['retry']).to eq(5)
    end

    it 'has Sidekiq queue set to :medium' do
      expect(CourtCaseWorker.sidekiq_options['queue']).to eq(:medium)
    end
  end
end
