require 'rails_helper'

RSpec.describe Importers::OkSos::AuditLogs do
  describe '#perform' do
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/audit_logs.csv') }

    before do
      response = double('response', { body: double('body', { string: sample_file }) })
      allow(Bucket).to receive(:new).and_return(bucket)
      allow(bucket).to receive(:get_object).and_return(response)
    end

    it 'does the import' do
      described_class.perform

      record = OkSos::AuditLog.first
      # Verify agent update
      expect(record).not_to be_nil
    end
  end
end
