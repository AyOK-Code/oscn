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

  # https://betterprogramming.pub/using-environment-variables-with-rspec-unit-tests-f094b400c299
  describe '.active' do
    it 'returns case types that are included in the CASE_TYPES_ABBREVIATION ENV variable' do
      skip
    end

    it 'filters out case types that are not included in the CASE_TYPES_ABBREVIATION ENV variable' do
      skip
    end
  end

  describe '#oscn_id_mapping' do
    it 'returns a hash of with key = :abbreviation and value = :id' do
      skip
    end
  end
end
