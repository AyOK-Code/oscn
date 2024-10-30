require 'rails_helper'

RSpec.describe ReportOcisCountiesEviction, type: :model do
  describe 'associations' do
    it { should belong_to(:county) }
    it { should belong_to(:court_case) }
  end
end
