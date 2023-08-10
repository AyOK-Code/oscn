require 'rails_helper'

RSpec.describe Roster do
  describe 'associations' do
    it { is_expected.to have_many(:case_parties) }
    it { is_expected.to have_many(:doc_profiles).class_name('Doc::Profile') }
  end
end
