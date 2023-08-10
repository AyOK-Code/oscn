require 'rails_helper'

RSpec.describe IssueParty do
  describe 'associations' do
    it { is_expected.to belong_to(:issue) }
    it { is_expected.to belong_to(:party) }
    it { is_expected.to belong_to(:verdict) }
  end
end
