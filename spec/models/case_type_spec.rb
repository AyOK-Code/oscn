require 'rails_helper'

RSpec.describe CaseType, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:abbreviation) }
    it { should validate_presence_of(:oscn_id) }
  end
end
