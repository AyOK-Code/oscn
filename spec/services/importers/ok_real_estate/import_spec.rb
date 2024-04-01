require 'rails_helper'

RSpec.describe Importers::OkRealEstate::Import do
  describe '.perform' do
    it 'creates a new instance and calls perform' do
      instance = instance_double('Importers::OkRealEstate::Import')
      allow(Importers::OkRealEstate::Import).to receive(:new).and_return(instance)
      expect(instance).to receive(:perform)

      described_class.perform
    end
  end

  describe '#perform' do
    subject(:import_instance) { described_class.new }

    it 'calls import_agents and import_agent_details' do
      expect(import_instance).to receive(:import_agents)
      expect(import_instance).to receive(:import_agent_details)

      import_instance.perform
    end
  end

  describe '#import_agents' do
    # Example test - adjust according to actual behavior
    it 'imports agents with progress bar updates' do
      allow_any_instance_of(ProgressBar).to receive(:increment!)

      # Assuming Importers::OkRealEstate::Agent responds to :new and :perform
      agent_importer = instance_double('Importers::OkRealEstate::Agent', fetch_count: 100)
      allow(Importers::OkRealEstate::Agent).to receive(:new).with(10, 0).and_return(agent_importer)
      allow(Importers::OkRealEstate::Agent).to receive(:perform)

      expect { described_class.new.import_agents }.not_to raise_error
    end
  end

  describe '#import_agent_details' do
    # Example test - adjust according to actual behavior
    it 'imports agent details with progress bar updates' do
      allow_any_instance_of(ProgressBar).to receive(:increment!)

      # Assuming OkRealEstate::Agent responds to :needs_scrape
      fake_agents = Array.new(10) { double('Agent', external_id: 123) }
      allow(OkRealEstate::Agent).to receive(:needs_scrape).and_return(fake_agents)
      allow(Importers::OkRealEstate::AgentDetail).to receive(:perform)

      expect { described_class.new.import_agent_details }.not_to raise_error
    end
  end
end
