require 'rails_helper'

RSpec.describe Parcel, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:geoid20) }

    it { should validate_presence_of(:tract) }
    it { should validate_presence_of(:block) }
  end
end
