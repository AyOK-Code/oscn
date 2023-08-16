require 'rails_helper'

RSpec.describe Plea do
  describe 'associations' do
    it { is_expected.to have_many(:counts).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
