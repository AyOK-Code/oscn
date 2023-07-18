require 'rails_helper'

RSpec.describe IssueParty, type: :model do
  describe 'associations' do
    it { should belong_to(:issue) }
    it { should belong_to(:party) }
    it { should belong_to(:verdict) }
  end
end
