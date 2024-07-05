require 'rails_helper'

RSpec.describe DatabaseUpdateWorker, type: :worker do
  describe '#perform' do
    let(:county_id) { 'sample_county' }
    let(:case_number) { 'CF-2018-1016' }
    let(:args) { { 'county_id' => county_id, 'case_number' => case_number } }

    it 'calls the CourtCase importer with the provided arguments' do
      expect(Importers::CourtCase).to receive(:perform).with(county_id, case_number)

      subject.perform(args)
    end

    it 'is a Sidekiq worker' do
      expect(DatabaseUpdateWorker).to include(Sidekiq::Worker)
    end

    it 'has Sidekiq retry options set to 5' do
      expect(DatabaseUpdateWorker.sidekiq_options['retry']).to eq(5)
    end

    it 'has Sidekiq queue set to :medium' do
      expect(DatabaseUpdateWorker.sidekiq_options['queue']).to eq(:medium)
    end
  end
end
