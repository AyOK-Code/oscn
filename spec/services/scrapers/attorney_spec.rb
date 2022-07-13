require 'rails_helper'

RSpec.describe Scrapers::Attorney do
  describe '#perform' do
    it 'add specs' do
      described_class.perform
    end
  end
end
