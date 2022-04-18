require 'rails_helper'

RSpec.describe Doc::OffenseCode, type: :model do
  describe 'associations' do
    it {
      should have_many(:sentences)
        .class_name('Doc::Sentence')
        .with_foreign_key('doc_offense_code_id')
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:statute_code) }
    it { should validate_presence_of(:description) }
  end
end
