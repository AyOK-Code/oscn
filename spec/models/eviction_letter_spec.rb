require 'rails_helper'

RSpec.describe EvictionLetter, type: :model do
  describe 'associations' do
    it { should belong_to(:docket_event_link) }
  end
end
