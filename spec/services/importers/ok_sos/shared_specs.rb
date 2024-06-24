require 'rails_helper'

RSpec.shared_examples 'ok_sos_importer' do
  describe '#perform' do

    # context "with a sample file" do

      let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/audit_logs.csv') }
      let(:bucket) { instance_double(Bucket) }

      before do
        response = double('response', { body: double('body', { string: sample_file }) })
        allow(Bucket).to receive(:new).and_return(bucket)
        allow(bucket).to receive(:get_object).and_return(response)
      end

      it 'does the import' do
        described_class.perform

        expect(record).to have_attributes expected_attributes
      end
    # end
  end
end