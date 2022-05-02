require 'rails_helper'

RSpec.describe Importers::Judge do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/judge.json' }
    let(:test_data) { parse_json(file_path) }
    let(:court_case) { create(:court_case) }
    let(:log) { ::Importers::Logger.new(court_case) }
    it 'add specs' do
      # variable in judge importer, judge doesnt specify json, could it maybe just take in a string?
      judge_test = create(:judge, name: 'Palumbo, Amy')
      described_class.perform('Palumbo, Amy', court_case, log)
      expect(court_case.current_judge_id).to eq(judge_test.id)
    end
  end
end
