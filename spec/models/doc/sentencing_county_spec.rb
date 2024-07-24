require 'rails_helper'

RSpec.describe Doc::SentencingCounty, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
  describe 'associations' do
    it { should belong_to(:county).class_name('County').optional }
  end
end
