require 'rails_helper'

RSpec.describe Census::Data, type: :model do
  describe 'associations' do
    it { should belong_to(:statistic).class_name('Census::Statistic') }
    it { should belong_to(:area).class_name('Census::Statistic') }
  end
end