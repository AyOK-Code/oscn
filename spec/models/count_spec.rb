require 'rails_helper'

RSpec.describe Count do
  describe 'associations' do
    it { is_expected.to belong_to(:court_case) }
    it { is_expected.to belong_to(:party) }
    it { is_expected.to belong_to(:plea).optional }
    it { is_expected.to belong_to(:verdict).optional }
    it { is_expected.to belong_to(:filed_statute_code).class_name('CountCode') }
    it { is_expected.to belong_to(:disposed_statute_code).class_name('CountCode').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:filed_statute_violation) }
  end
end
