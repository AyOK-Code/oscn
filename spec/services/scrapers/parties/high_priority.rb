require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Parties::HighPriority do
  describe '#perform' do
    context 'when there is a party with no html' do
      let!(:party_no_html) { create(:party) }

      it 'adds jobs to the PartyWorker' do
        create(:party, :with_html)
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(1)
        end
      end
    end

    context 'when the party is enqueued' do
      let!(:party_enqueued) { create(:party, enqueued: true) }

      it 'doesnt add jobs to the PartyWorker' do
        expect do
          described_class.perform.not_to change(PartyWorker.jobs, :size)
        end
      end
    end

    context 'when there is a party with no html and no oscn_id' do
      let!(:party_no_oscn) { create(:party, oscn_id: nil) }

      it 'doesnt add jobs to the PartyWorker' do
        expect do
          described_class.perform.not_to change(PartyWorker.jobs, :size)
        end
      end
    end

    context 'when there is a party with html' do
      let!(:party_with_html) { create(:party, :with_html) }

      it 'doesn\'t add jobs to the PartyWorker' do
        expect do
          described_class.perform.not_to change(PartyWorker.jobs, :size)
        end
      end
    end
  end
end
