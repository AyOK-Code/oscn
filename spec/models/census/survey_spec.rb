require 'rails_helper'

RSpec.describe Census::Survey, type: :model do
  describe 'associations' do
    it { should have_many(:statistics).class_name('Census::Statistic').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:year) }
  end
end
