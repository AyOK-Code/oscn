require 'rails_helper'

RSpec.describe CaseType, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:abbreviation) }
    it { should validate_presence_of(:oscn_id) }
  end

  describe 'associations' do
    it { should have_many(:court_cases).dependent(:destroy) }
  end

  describe '.active' do
    it 'returns case types that are included in the CASE_TYPES_ABBREVIATION ENV variable' do
      create(:case_type, abbreviation: 'CF')
      expect(described_class.active.size).to eq(1)
    end

    it 'filters out case types that are not included in the CASE_TYPES_ABBREVIATION ENV variable' do
      create(:case_type, abbreviation: 'ZZ')
      expect(described_class.active.size).to eq(0)
    end
  end

  describe '#oscn_id_mapping' do
    it 'returns a hash of with key = :abbreviation and value = :id' do
      cassygood = create(:case_type, abbreviation: 'CF')
      cassygood2 = create(:case_type, abbreviation: 'CM')
      create(:case_type, abbreviation: 'ZZ')
      expect(described_class.oscn_id_mapping.size).to eq(2)
      expect(described_class.oscn_id_mapping.values).to include(cassygood.id, cassygood2.id)
    end
  end
end
