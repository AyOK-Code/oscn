require 'rails_helper'

RSpec.describe Count, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
    it { should belong_to(:plea).optional }
    it { should belong_to(:verdict).optional }
    it { should belong_to(:filed_statute_code).class_name('CountCode') }
    it { should belong_to(:disposed_statute_code).class_name('CountCode').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filed_statute_violation) }
  end
end
