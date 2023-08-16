require 'rails_helper'

RSpec.describe DocSentencingCounty do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:county).class_name('County').optional }
  end
end
