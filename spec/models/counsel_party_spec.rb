require 'rails_helper'

RSpec.describe CounselParty do
  describe 'associations' do
    it { is_expected.to belong_to(:court_case) }
    it { is_expected.to belong_to(:party) }
    it { is_expected.to belong_to(:counsel) }
  end
end
