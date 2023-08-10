require 'rails_helper'

RSpec.describe CountCode do
  describe 'associations' do
    it {
      expect(subject).to have_many(:filed_counts).class_name('Count').with_foreign_key('filed_statute_code_id').dependent(:destroy)
    }

    it {
      expect(subject).to have_many(:disposed_counts)
        .class_name('Count')
        .with_foreign_key('disposed_statute_code_id')
        .dependent(:destroy)
    }

    it { is_expected.to have_many(:issues).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
  end
end
