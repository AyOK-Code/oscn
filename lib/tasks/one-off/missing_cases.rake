require 'open-uri'
# require './db/CaseInfo.rb'
require './config/initializers/case_types'

namespace :save do
  desc 'Find Missing Cases'
  task missing_cases: [:environment] do
    # case_types = CaseInfo::CASE_TYPES
    # counties = CaseInfo::COUNTIES
    years = Array(2012..2022)
    name = ENV['COUNTIES']
    binding.pry

    CASE_TYPES.each do |type|
      years.each do |year|
        sub_year = "\-#{year}-(.*)"
        type_year = "#{type}-#{year}"
        results = ActiveRecord::Base.connection.execute("SELECT *  FROM generate_series(0, 500) AS case_indexes WHERE case_indexes
          NOT IN (SELECT substring(case_number, '\-2012-(.*)')::integer
          as case_index from court_cases where case_number ~ 'CF-2012')")
        binding.pry
      end
    end
  end
end
