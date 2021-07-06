require 'rails_helper'

RSpec.describe Counsel, type: :model do
  context 'associations' do
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:parties).through(:counsel_parties) }
  end

  context 'validations' do
    context 'has a bar_number' do
      before { allow(subject).to receive(:has_bar_number?).and_return(true) }
      it { should validate_uniqueness_of(:bar_number) }
    end

    context 'bar_number is nil' do
      before { allow(subject).to receive(:has_bar_number?).and_return(false) }
      it { should_not validate_uniqueness_of(:bar_number) }
    end
  end
end
