require 'rails_helper'

RSpec.describe Census::Statistic, type: :model do
  describe 'associations' do
    it { should belong_to(:survey).class_name('Census::Survey') }
    it { should have_many(:datas).class_name('Census::Data').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:label) }
    it { should validate_presence_of(:survey) }
    it { should validate_presence_of(:concept) }
    it { should validate_presence_of(:group) }
  end
end