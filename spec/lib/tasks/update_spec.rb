require 'rails_helper'
require 'rake'

RSpec.describe 'update', type: :task do
  describe 'is_error' do
    after(:each) do
      Rake::Task['update:is_error'].reenable
    end

    context 'when there are error cases and valid cases' do
      let!(:empty_error_case) { create(:court_case) }
      let!(:docket_error_case) do
        create(:court_case, docket_events: [create(:docket_event, description: 'CASE FILED IN ERROR')])
      end
      let!(:valid_case) { create(:court_case, :with_docket_event) }

      it 'it updates is_error flag on error cases only' do
        Rake::Task['update:is_error'].invoke
        expect(empty_error_case.reload.is_error).to be true
        expect(docket_error_case.reload.is_error).to be true
        expect(valid_case.reload.is_error).to be false
      end
    end
  end
end
