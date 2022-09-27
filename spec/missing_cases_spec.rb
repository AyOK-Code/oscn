require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'save' do
  describe 'missing_cases' do
    ENV['COUNTIES'] = 'Tulsa'
    let!(:county) { create(:county, name: ENV['COUNTIES']) }
    let!(:case_type) { create(:case_type, name: 'Criminal Felony', abbreviation: 'CF') }
    let!(:court_case1) { create(:court_case, case_number: 'CF-2012-1') }
    let!(:court_case2) { create(:court_case, case_number: 'CF-2012-2') }
    let!(:court_case3) { create(:court_case, case_number: 'CF-2012-3') }
    let!(:court_case4) { create(:court_case, case_number: 'CF-2012-5') }

    it 'finds missing task' do
      Rake::Task['save:missing_cases'].invoke

      expect(CourtCase.where(case_number: 'CF-2012-4').exists?).to eq true
    end
  end
end
