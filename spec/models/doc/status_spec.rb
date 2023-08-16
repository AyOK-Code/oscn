require 'rails_helper'

RSpec.describe Doc::Status do
  describe 'associations' do
    it { is_expected.to belong_to(:profile).class_name('Doc::Profile').with_foreign_key('doc_profile_id') }
  end
end
