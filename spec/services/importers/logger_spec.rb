require 'rails_helper'

RSpec.describe Importers::Logger do
  let(:file_path) { 'spec/fixtures/importers/count_data.json' }
  let(:test_data) { parse_json(file_path) }
  let(:court_case) { create(:court_case) }
  let(:party) { create(:party, full_name: 'PIT, ANTHONY LEE') }
  let(:log) { ::Importers::Logger.new(court_case) }
  describe '#update_logs' do
    it 'updates  court case log if logs are present with a log' do
      count_data = test_data.first
      log.create_log('counts', "#{court_case.case_number} skipped count due to missing party.", count_data)
      log.update_logs
      expect(court_case.logs.size).to eq(1)
    end

    it 'updates  court case log if logs are not present with nil' do
      log.update_logs
      expect(court_case.logs).to eq(nil)
    end
  end

  describe '#create_log' do
    it 'creates a log' do
      count_data = test_data.first

      log.create_log('counts', "#{court_case.case_number} skipped count due to missing party.", count_data)

      expect(log.logs.size).to eq(1)
    end
  end
end
