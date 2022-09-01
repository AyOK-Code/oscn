require 'open-uri'
# require './db/CaseInfo.rb'
require './config/initializers/case_types'

namespace :save do
  desc 'Find Missing Cases'
  task missing_cases: [:environment] do
    # case_types = CaseInfo::CASE_TYPES
    # counties = CaseInfo::COUNTIES
    years = Array(2012..2013)
    name = ENV['COUNTIES']


    county = County.find_by!(name: ENV['COUNTIES'])
 #   counties = County.where(name: ENV['COUNTIES'].split(','))]
#counties.each
#https://www.rubyguides.com/2018/11/ruby-heredoc/

    CASE_TYPES.each do |type|
      case_type = CaseType.find_or_initialize_by(abbreviation: 'CF')
      years.each do |year|
        sub_year = "\-#{year}-(.*)"
        type_year = "#{type}-#{year}"
        sql1 = <<-SQL
        SELECT substring(case_number, '#{sub_year}')::integer as case_index
        from court_cases
        where case_number ~ '#{type_year}'
        order by case_index desc
        limit 1

                SQL
                max = ActiveRecord::Base.connection.execute(sql1)
                
                if max.values.empty?
                  next
                end

              
        sql = <<-SQL
        SELECT *  FROM generate_series(1,#{max.getvalue(0,0)}) AS case_indexes WHERE case_indexes
        NOT IN (SELECT substring(case_number, '#{sub_year}')::integer
        as case_index from court_cases where case_number ~ '#{type_year}')
                SQL
                  
          
        query = ActiveRecord::Base.connection.execute(sql)

        results = query.flat_map { |a| a['case_indexes'] }

        results.each do |number|
          case_number = "#{type}-#{year}-#{number}"
          
          oscn = Faker::Number.between(from: 1, to: 1000)
          c = ::CourtCase.find_or_initialize_by(case_number: case_number, county: county, case_type: case_type,
                                                oscn_id: oscn)

          c.save!
        end
      end
    end
  end
end
