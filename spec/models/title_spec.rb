require 'rails_helper'

RSpec.describe Title do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
