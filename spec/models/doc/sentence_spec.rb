require 'rails_helper'

RSpec.describe Doc::Sentence do
  describe 'associations' do
    it { is_expected.to belong_to(:profile).class_name('Doc::Profile') }
    it { is_expected.to belong_to(:offense_code).class_name('Doc::OffenseCode').optional }
  end
end
