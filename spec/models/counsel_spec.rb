require 'rails_helper'

RSpec.describe Counsel do
  describe 'associations' do
    it { is_expected.to have_many(:counsel_parties).dependent(:destroy) }
    it { is_expected.to have_many(:parties).through(:counsel_parties) }
  end

  describe 'validations' do
    context 'has a bar_number' do
      before { allow(subject).to receive(:bar_number?).and_return(true) }

      it { is_expected.to validate_uniqueness_of(:bar_number) }
    end

    context 'bar_number is nil' do
      before { allow(subject).to receive(:bar_number?).and_return(false) }

      it { is_expected.not_to validate_uniqueness_of(:bar_number) }
    end
  end

  describe '.bar_number?' do
    it 'returns true in bar number is present' do
      counsel = create(:counsel)
      counselbad = create(:counsel, bar_number: nil)

      expect(counsel.bar_number?).to be(true)
      expect(counselbad.bar_number?).to be(false)
    end
  end
end
