require 'rails_helper'

RSpec.describe StructureFireLink, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:url) }
  end
end
