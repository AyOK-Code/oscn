require 'open-uri'

namespace :doc do
  desc 'Pull in attorneys from OK Bar site'
  task :sentencing_counties do
    county_court = ActiveRecord::Base.connection.execute("SELECT DISTINCT sentencing_county from doc_sentences where sentencing_county ilike '%county court%' order by sentencing_county")

    county_court = county_court.column_values(0).sort
    sent_counties = ::Doc::Sentence.distinct.pluck(:sentencing_county).sort
    
    
 
    sent_counties.each do |sent|
        
        

        sentence = Doc::Sentence.where(sentencing_county: sent).in_batches
        
        if county_court.include?  sent  and sent != 'UNKNOWN COUNTY COURT'
            county = County.where('lower(name) = ?',sent.split(' COUNTY COURT').first.downcase).first
            
            doc_sent = DocSentencingCounty.find_or_initialize_by(name: sent,county_id: county.id)
            doc_sent.save
            sentence.update_all(doc_sentencing_county_id:doc_sent.id)
            
        else
          
          doc_sent = DocSentencingCounty.find_or_initialize_by(name: sent)
            doc_sent.save
            
            sentence.update_all(doc_sentencing_county_id:doc_sent.id)

        end
        

    end
  end
end
