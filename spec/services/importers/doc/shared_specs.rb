require 'rails_helper'

puts "test"

RSpec.shared_examples 'doc_importer' do
  describe '#perform' do
    context 'when connecting to aws' do
      it 'imports the file' do
        VCR.use_cassette('doc_2023_01') do
          original_count = class_to_import.count
          described_class.new('2023-01').perform
          expect(class_to_import.count).to be > original_count
        end
      end
    end

    context 'with a dat sample file' do
      let(:bucket) { instance_double(Bucket) }

      before do
        response = double('response', { body: double('body', { string: file }) })
        allow(Bucket).to receive(:new).and_return(bucket)
        allow(bucket).to receive(:get_object).and_return(response)
      end

      it 'imports the data' do
        described_class.new('2023-01').perform
        expect(class_to_import.count).to be > 0
      end

      context 'with an invalid dat file (with too many columns)' do
        let(:file) { invalid_spacing_file }
        it 'raises an exception' do
          expect { described_class.new('2023-01').perform }.to raise_error(Exception, /^File not valid./)
        end
      end
    end
  end
end
