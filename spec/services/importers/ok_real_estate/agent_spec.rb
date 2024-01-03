require 'rails_helper'

module Importers
  module OkRealEstate
    RSpec.describe Agent do
      describe '.perform' do
        it 'calls new and perform on an instance' do
          agent_importer = instance_double('Importers::OkRealEstate::Agent')
          allow(Agent).to receive(:new).with(10, 0).and_return(agent_importer)
          expect(agent_importer).to receive(:perform)

          Agent.perform(10, 0)
        end
      end

      describe '#perform' do
        let(:fixture_file) { File.read('spec/fixtures/agent.json') }
        let(:fixture_data) { JSON.parse(fixture_file) }

        before do
          stub_request(:get, /orec.us.thentiacloud.net/).to_return(body: fixture_file)
        end

        it 'imports agents from fixture data' do
          agent_importer = Agent.new(10, 0)
          expect { agent_importer.perform }.not_to raise_error

          fixture_data['result'].each do |agent_json|
            agent = ::OkRealEstate::Agent.find_by(external_id: agent_json['id'])
            expect(agent).not_to be_nil
            # Add more expectations here for agent attributes
          end
        end
      end

      describe '#fetch_count' do
        let(:fixture_file) { File.read('spec/fixtures/agent.json') }
        let(:fixture_data) { JSON.parse(fixture_file) }

        before do
          stub_request(:get, /orec.us.thentiacloud.net/).to_return(body: fixture_file)
        end

        it 'returns the correct count from fixture data' do
          agent_importer = Agent.new(10, 0)
          expect(agent_importer.fetch_count).to eq(fixture_data['resultCount'])
        end
      end
    end
  end
end
