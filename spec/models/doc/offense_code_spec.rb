require 'rails_helper'

RSpec.describe Doc::OffenseCode do
  describe 'associations' do
    it {
      expect(subject).to have_many(:sentences)
        .class_name('Doc::Sentence')
        .with_foreign_key('doc_offense_code_id')
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:statute_code) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
