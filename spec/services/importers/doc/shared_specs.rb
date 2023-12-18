require 'rails_helper'

RSpec.shared_examples 'doc_importer' do
  describe '#perform' do
    context 'when connecting to aws' do
      xit 'imports the file' do
        VCR.use_cassette("large/#{described_class}_doc_2023_04") do
          original_count = class_to_import.count
          described_class.new('2023-04').perform
          expect(class_to_import.count).to be > original_count
        end
      end
    end

    context 'with a dat sample file' do
      let(:bucket) { instance_double(Bucket) }

      before do
        #binding.pry
        response = double('response', { body: double('body', { string: sample_file }) })
        allow(Bucket).to receive(:new).and_return(bucket)
        allow(bucket).to receive(:get_object).and_return(response)
      end

      it 'imports the data' do
        described_class.new('2023-01').perform
        binding.pry
        expect(class_to_import.count).to be > 0
        expect(class_to_import.first).to have_attributes(expected_attributes)
      end
    end
  end
end
