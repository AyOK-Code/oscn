require 'rails_helper'

RSpec.describe Doc::Profile do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:doc_number) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to define_enum_for(:status) }
    it { is_expected.to define_enum_for(:sex) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:roster).optional }

    it {
      expect(subject).to have_many(:aliases).class_name('Doc::Alias').with_foreign_key('doc_profile_id').dependent(:destroy)
    }

    it {
      expect(subject).to have_many(:sentences).class_name('Doc::Sentence').with_foreign_key('doc_profile_id').dependent(:destroy)
    }

    it {
      expect(subject).to have_many(:statuses).class_name('Doc::Status').with_foreign_key('doc_profile_id').dependent(:destroy)
    }
  end
end
