require 'rails_helper'

RSpec.shared_examples 'ok_assessor_importer' do
  describe '#perform' do
    it 'does the import' do
      obj = described_class.new
      allow(obj).to receive(:file).and_return(sample_file)
      obj.perform
      expect(record).to have_attributes expected_attributes
    end
  end
end
