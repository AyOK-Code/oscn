require 'rails_helper'

RSpec.describe DocketEventLink, type: :model do
  describe 'associations' do
    it { should belong_to(:docket_event) }
  end
end
