require 'rails_helper'

RSpec.describe EvictionFile, type: :model do
  describe 'associations' do
    it { should have_many(:eviction_letters).dependent(:nullify) }
    it { should have_one_attached(:file) }
  end
end
