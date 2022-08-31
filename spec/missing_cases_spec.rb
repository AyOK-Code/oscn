require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'save' do
  describe 'missing_cases' do
    let!(:court_case1) { create(:court_case) }
    let!(:court_case2) { create(:court_case) }
    let!(:court_case3) { create(:court_case) }
    let!(:court_case4) { create(:court_case) }

    it 'finds missing task' do
      ENV['COUNTIES'] = 'Tulsa'
      Rake::Task['save:missing_cases'].invoke
    end
  end
end
