require 'rails_helper'

RSpec.describe Verdict do
  describe 'associations' do
    it { is_expected.to have_many(:counts).dependent(:destroy) }
    it { is_expected.to have_many(:issue_parties).dependent(:destroy) }
    it { is_expected.to have_many(:issues).through(:issue_parties) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
