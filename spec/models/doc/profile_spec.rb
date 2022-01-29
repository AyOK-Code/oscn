require 'rails_helper'

RSpec.describe Doc::Profile, type: :model do
  context 'validations' do
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:doc_number) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:sex) }
    it { should define_enum_for(:status) }
    it { should define_enum_for(:sex) }
  end

  context 'associations' do
    it { should have_many(:aliases).class_name('Doc::Alias').with_foreign_key('doc_profile_id').dependent(:destroy) }
    it { should have_many(:sentences).class_name('Doc::Sentence').with_foreign_key('doc_profile_id').dependent(:destroy) }
  end
end
