require 'rails_helper'
require 'rake'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

Rails.application.load_tasks

RSpec.describe "scrape:court_cases" do

  before do
    allow(DailyFilingWorker).to receive(:perform_async).and_return('Queued worker')
  end

  it "queues up the daily filing worker for the given time frame" do
    expect do
      Rake::Task["scrape:court_cases"].invoke(2020, 'Oklahoma', 1)
    end.to change(DailyFilingWorker.jobs, :size).by(31)
  end
end