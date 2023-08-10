require 'rails_helper'

RSpec.describe OklahomaStatute do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:ten_digit) }
    it { is_expected.to validate_presence_of(:severity) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:effective_on) }
  end
end
