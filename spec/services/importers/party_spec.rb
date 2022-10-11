require 'rails_helper'

RSpec.describe Importers::Party do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/party_data.json' }
    let(:test_data) { parse_json(file_path) }
    let(:court_case) { create(:court_case) }
    let(:log) { ::Importers::Logger.new(court_case) }

    context 'party does not exist' do
      it 'creates a party' do
        described_class.perform(test_data, court_case, log)

        expect(Party.all.size).to eq(2)
      end

      it 'links new party to the case' do
        described_class.perform(test_data, court_case, log)
        expect(court_case.parties.first.full_name.squish).to eq(test_data.first[:name].squish)
      end
    end

    context 'party does exist' do
      it 'does not duplicate existing parties' do
        create(:party, oscn_id: 18_498_184, full_name: 'PENA,  ANTHONY  RAMIRO')
        described_class.perform(test_data, court_case, log)

        expect(Party.all.size).to eq(2)
      end

      it 'updates a party name if it changes' do
        create(:party, oscn_id: 18_498_184, full_name: 'PENA,  ANT  RAMIRO')
        described_class.perform(test_data, court_case, log)
        party = ::Party.find_by(oscn_id: 18_498_184)
        expect(party.full_name).to eq 'PENA,  ANTHONY  RAMIRO'
      end

      it 'links a party to a case' do
        create(:party, oscn_id: 18_498_184, full_name: 'PENA,  ANTHONY  RAMIRO')
        described_class.perform(test_data, court_case, log)
        uri = URI(test_data.first[:link])
        params = CGI.parse(uri.query)

        expect(court_case.parties.first.oscn_id).to eq(params['id'].first.to_i)
      end

      it 'creates a party type if it does not exist' do
        described_class.perform(test_data, court_case, log)
        expect(PartyType.all.size).to eq(2)
      end
    end
  end
end
