require 'rails_helper'

RSpec.describe ReportCriminalCase, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:county) }
  end
end
