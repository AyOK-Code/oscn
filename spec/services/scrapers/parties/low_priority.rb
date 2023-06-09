require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Parties::HighPriority do
  describe '#perform' do
    context 'when the party is enqueued' do
      let!(:party_enqueued) { create(:party, enqueued: true) }

      it ' doesnt add  jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(0)
        end
      end
    end

    context 'when there is a recently scraped party' do
      let!(:recently_scraped_party) do
        create(:party, party_html: build(:party_html, scraped_at: Time.current - 1.day))
      end

      it 'doesn\'t add jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(0)
        end
      end
    end
    context 'when there is a party with no html and no oscn_id' do
      let!(:party_no_oscn) do
        create(:party, oscn_id: nil)
      end

      it 'doesnt add jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(0)
        end
      end
    end

    context 'when there is a party that hasn\'t been scraped in a while' do
      let!(:old_party) do
        create(:party, party_html: build(:party_html, scraped_at: Time.current - 1.year))
      end

      it 'adds jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(1)
        end
      end
    end
  end
end
