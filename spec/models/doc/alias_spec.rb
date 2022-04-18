require 'rails_helper'

RSpec.describe Doc::Alias, type: :model do
  describe 'associations' do
    it { should belong_to(:doc_profile).class_name('Doc::Profile') }
  end

  describe 'validations' do
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:doc_number) }
  end
end
