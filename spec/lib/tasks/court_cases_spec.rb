require 'rails_helper'
require 'rake'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe 'scrape:court_cases', type: :task do
  it 'queues up the daily filing worker for the given time frame' do
    expect do
      Rake::Task['scrape:court_cases'].invoke(2020, 'Oklahoma', 1)
    end.to change(DailyFilingWorker.jobs, :size).by(31)
    expect(DailyFilingWorker.jobs.first['args']).to eq(['Oklahoma', '2020-01-01']
  end
end
