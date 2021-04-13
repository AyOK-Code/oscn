require 'rails_helper'

RSpec.describe Case, type: :model do
  context 'validations' do
    it { should validate_presence_of(:oscn_id) }
    it { should validate_presence_of(:case_number) }
    it { should validate_presence_of(:filed_on) }
    it { should validate_presence_of(:html) }
  end

  context 'associations' do
    it { should belong_to(:county) }
    it { should belong_to(:case_type) }
  end
end
