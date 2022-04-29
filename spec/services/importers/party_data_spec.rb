require 'rails_helper'

RSpec.describe Importers::PartyData do
  describe '#perform(oscn_id)' do
    it 'saves aliases' do
      path = 'spec/fixtures/party_example.html'
      html = File.open(path).read
      party_html = create(:party_html, html: html)
      party = party_html.party

      described_class.perform(party.oscn_id)
      expect(party.aliases.size).to eq 2
    end
  end
end
