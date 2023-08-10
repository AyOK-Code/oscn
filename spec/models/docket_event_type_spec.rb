require 'rails_helper'

RSpec.describe DocketEventType do
  describe 'associations' do
    it { is_expected.to have_many(:docket_events).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
