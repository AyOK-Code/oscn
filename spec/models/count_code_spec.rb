require 'rails_helper'

RSpec.describe CountCode, type: :model do
  describe 'associations' do
    it {
      should have_many(:filed_counts).class_name('Count').with_foreign_key('filed_statute_code_id').dependent(:destroy)
    }
    it {
      should have_many(:disposed_counts)
        .class_name('Count')
        .with_foreign_key('disposed_statute_code_id')
        .dependent(:destroy)
    }
    it { should have_many(:issues).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
  end
end
