require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe 'associations' do
    it { should belong_to(:count_code) }
    it { should belong_to(:court_case) }
    it { should belong_to(:filed_by).class_name('Party') }
    it { should have_many(:issue_parties).dependent(:destroy) }
  end
end
