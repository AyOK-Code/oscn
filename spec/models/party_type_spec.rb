require 'rails_helper'

RSpec.describe PartyType, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
