require 'rails_helper'

RSpec.describe Doc::Sentence, type: :model do
  context 'associations' do
    it { should belong_to(:profile).class_name('Doc::Profile') }
    it { should belong_to(:offense_code).class_name('Doc::OffenseCode').optional }
  end
end
