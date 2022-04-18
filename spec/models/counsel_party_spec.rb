require 'rails_helper'

RSpec.describe CounselParty, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
    it { should belong_to(:counsel) }
  end
end
