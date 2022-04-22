require 'rails_helper'

RSpec.describe Importers::Party do
  describe '#perform' do
    it 'creates a party if it does not exist' do
      test_data = JSON.parse(File.open('spec/fixtures/importers/party_data.json').read)
      ap test_data
      court_case = create(:court_case)
      log = ::Importers::Logger.new(court_case)
      described_class.perform(test_data,court_case,log)
      #binding.pry
      expect(Party.all.size).to eq(1)
      expect(court_case.parties.first.full_name).to eq(test_data.first[:name])
    end

    it 'does not duplicate existing parties' do

    end
  end
end
