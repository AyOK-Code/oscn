require 'rails_helper'

RSpec.describe Verdict, type: :model do
  describe 'associations' do
    it { should have_many(:counts).dependent(:destroy) }
    it { should have_many(:issue_parties).dependent(:destroy) }
    it { should have_many(:issues).through(:issue_parties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
