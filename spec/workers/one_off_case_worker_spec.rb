require 'rails_helper'

RSpec.describe OneOffCaseWorker, type: :worker do
  let!(:county) { create(:county, id: 55, name: 'Tulsa') }
  let(:case_number) { 'CF-2018-1016' }
  let!(:court_case) { create(:court_case, case_number: case_number, county: county) }

  describe '#perform' do
    context 'when the CourtCase does not exist' do
      it 'calls the OneOffCase scraper' do
        allow(CourtCase).to receive(:find_by).and_return(nil)
        expect(::Scrapers::OneOffCase).to receive(:perform).with(county.name, court_case.case_number)

        subject.perform(county.name, case_number)
      end
    end

    context 'when the CourtCase exists' do
      let!(:court_case) { create(:court_case, county: county, case_number: case_number) }

      it 'does not call OneOffCase' do
        allow(CourtCase).to receive(:find_by).and_return(court_case)
        allow(::Importers::CourtCase).to receive(:perform)
        expect(::Scrapers::OneOffCase).to_not receive(:perform).with(county.name, court_case.case_number)
        expect(::Importers::CourtCase).to receive(:perform).with(county.id, case_number)

        subject.perform(county.name, case_number)
      end
    end

    it 'raises an error when county is not found' do
      missing_county = 'Nowhere County'

      expect do
        subject.perform(missing_county, case_number)
      end.to raise_error(StandardError, 'County not found')
    end
  end

  it 'is a Sidekiq worker' do
    expect(OneOffCaseWorker).to include(Sidekiq::Worker)
  end

  it 'is a Sidekiq throttled worker' do
    expect(OneOffCaseWorker).to include(Sidekiq::Throttled::Worker)
  end

  it 'has Sidekiq retry options set to 5' do
    expect(OneOffCaseWorker.sidekiq_options['retry']).to eq(5)
  end

  it 'has Sidekiq queue set to :medium' do
    expect(OneOffCaseWorker.sidekiq_options['queue']).to eq(:medium)
  end
end
