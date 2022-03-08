require 'rails_helper'

RSpec.describe Doc::Status, type: :model do
  context 'associations' do
    it { should belong_to(:profile).class_name('Doc::Profile').with_foreigh_key('doc_profile_id') }
  end
end
