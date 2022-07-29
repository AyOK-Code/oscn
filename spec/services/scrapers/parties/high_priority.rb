require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Parties::HighPriority do
  describe '#perform' do
    context 'when there is a party with no html' do
      let!(:party_no_html) { create(:party) }

      it 'adds jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(1)
        end
      end
    end

    context 'when there is a test case with html' do
      let!(:party_with_html) { create(:party, :with_html) }

      it 'adds jobs to the PartyWorker' do
        expect do
          described_class.perform.to change(PartyWorker.jobs, :size).by(0)
        end
      end
    end
  end
end
