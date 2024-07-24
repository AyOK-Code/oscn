require 'rails_helper'

RSpec.shared_examples 'ok_sos_importer' do
  describe '#perform' do
    it 'does the import' do
      described_class.perform(sample_file)

      expect(record).to have_attributes expected_attributes
    end
  end
end
