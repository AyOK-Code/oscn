require 'rails_helper'

RSpec.describe OkRealEstate::Agent, type: :model do
  describe 'associations' do
    it { should have_many(:places).class_name('OkRealEstate::Place').dependent(:destroy) }
    it { should have_many(:histories).class_name('OkRealEstate::RegistrationHistory').dependent(:destroy) }
    it { should have_one(:record).class_name('OkRealEstate::RegistrationRecord').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:license_number) }
    it { should validate_presence_of(:license_expiration_on) }
  end

  describe '#needs_scrape' do
    it 'returns records with scraped_on is nil' do
      agent = create(:ok_real_estate_agent, scraped_on: nil)
      create(:ok_real_estate_agent, scraped_on: 1.day.ago)

      expect(described_class.needs_scrape.count).to eq(1)
      expect(described_class.needs_scrape.first).to eq(agent)
    end

    it 'returns records with scraped_on more than 1 month ago' do
      agent = create(:ok_real_estate_agent, scraped_on: 2.months.ago)
      create(:ok_real_estate_agent, scraped_on: 1.day.ago)

      expect(described_class.needs_scrape.count).to eq(1)
      expect(described_class.needs_scrape.first).to eq(agent)
    end
  end
end
