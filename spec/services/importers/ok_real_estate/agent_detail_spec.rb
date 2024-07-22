require 'rails_helper'

RSpec.describe Importers::OkRealEstate::AgentDetail do
  describe '.perform' do
    it 'calls new and perform on an instance' do
      detail_importer = instance_double('Importers::OkRealEstate::AgentDetail')
      allow(described_class).to receive(:new).with(1).and_return(detail_importer)
      expect(detail_importer).to receive(:perform)

      described_class.perform(1)
    end
  end

  describe '#perform' do
    let(:fixture_file) { File.read('spec/fixtures/importers/ok_real_estate/agent_detail.json') }
    let(:fixture_data) { JSON.parse(fixture_file) }
    # Adjust as per your factory setup
    let(:agent) do
      create(:ok_real_estate_agent, external_id: '5fe149a9fee7340388fcb992')
    end
    before do
      stub_request(:get, /orec.us.thentiacloud.net/).to_return(body: fixture_file,
                                                               headers: { content_type: 'application/json' })
      allow(::OkRealEstate::Agent).to receive(:find_by).with(external_id: '5fe149a9fee7340388fcb992').and_return(agent)
    end

    it 'updates agent and processes data from fixture' do
      detail_importer = described_class.new('5fe149a9fee7340388fcb992')
      expect { detail_importer.perform }.not_to raise_error

      # Verify agent update
      expect(agent.reload.scraped_on).not_to be_nil
      expect(agent.places.count).to eq(1)
      expect(agent.record.agent_id).to eq(agent.id)
      expect(agent.histories.count).to eq(9)
    end
  end
end
