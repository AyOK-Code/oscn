require 'rails_helper'

RSpec.describe Doc::Alias do
  describe 'associations' do
    it { is_expected.to belong_to(:doc_profile).class_name('Doc::Profile') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:doc_number) }
  end
end
