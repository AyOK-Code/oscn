require 'rails_helper'

RSpec.describe Doc::Status, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('Doc::Profile').with_foreign_key('doc_profile_id') }
  end
end
