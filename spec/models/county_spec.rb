require 'rails_helper'

RSpec.describe County do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:fips_code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:court_cases).dependent(:destroy) }
    it { is_expected.to have_many(:case_not_founds).dependent(:destroy) }
    it { is_expected.to belong_to(:district_attorney).class_name('DistrictAttorney').optional }
  end

  describe '#name_id_mapping' do
    it 'returns a hash of the name to id' do
      county = create(:county)
      mapping = described_class.name_id_mapping

      expect(mapping[county.name]).to eq county.id
    end
  end
end
