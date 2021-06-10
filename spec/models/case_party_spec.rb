require 'rails_helper'

RSpec.describe CaseParty, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
  end
end
