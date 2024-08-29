require 'rails_helper'

RSpec.shared_examples 'ok_assessor_importer' do
  describe '#perform' do
    let(:sample_file) { File.read("spec/fixtures/importers/ok_assessor/#{obj.file_name}") }
    let(:obj) { described_class.new }
    it 'does the import' do
      allow(obj).to receive(:file).and_return(sample_file)
      obj.perform
      expect(record).to have_attributes expected_attributes
    end
  end
end
