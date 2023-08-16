require 'rails_helper'

RSpec.describe DocketEventLink do
  describe 'associations' do
    it { is_expected.to belong_to(:docket_event) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:oscn_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:link) }
  end
end
