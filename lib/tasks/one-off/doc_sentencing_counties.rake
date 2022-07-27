require 'open-uri'

namespace :save do
  desc 'Pull in attorneys from OK Bar site'
  task :sentencing_counties do
    county_court = ActiveRecord::Base.connection.execute("SELECT DISTINCT sentencing_county from doc_sentences where sentencing_county ilike '%county court%' order by sentencing_county")
    #size: 83, these will link back to county table

    county_court = county_court.column_values(0).sort
    sent_counties = ::Doc::Sentence.distinct.pluck(:sentencing_county).sort
    #size:146
    
    # do I only create sentencing counties that mach in this collection?

    sent_counties.each do |sent|
        binding.pry
        sentence = Doc::Sentence.find_by  sentencing_county : sent
        if county_court.include? sent
            county = County.find_by name: sent.split(' ')[0].capitalize
            doc_sent = DocSentencingCounty.find_or_initialize_by(name: sent,county_id: county.id)
            doc_sent.save
            sentence.update(doc_sentencing_counties_id:doc_sent.id)
            sent.save 
            
        else
            DocSentencingCounty.find_or_initialize_by(name: sent)
            doc_sent.save
            sentence.update(doc_sentencing_counties_id:doc_sent.id)
            sent.save

        end
        

    end
  end
end
