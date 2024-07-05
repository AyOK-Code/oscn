require 'open-uri'

namespace :doc do
  desc 'Populates DocSentencingCounty and assignes it to Doc::Sentence'
  task sentencing_counties: [:environment] do
    sent_counties = Doc::Sentence.distinct.pluck(:sentencing_county).sort
    sent_counties.each do |sent|
      sentence = Doc::Sentence.where(sentencing_county: sent)

      if sent.upcase.include?('COUNTY COURT') && (sent != 'UNKNOWN COUNTY COURT')
        county = County.where('lower(name) = ?', sent.split(' COUNTY COURT').first.downcase).first

        doc_sent = DocSentencingCounty.find_or_initialize_by(name: sent, county_id: county.id)

      else

        doc_sent = DocSentencingCounty.find_or_initialize_by(name: sent)

      end
      doc_sent.save
      sentence.update_all(doc_sentencing_county_id: doc_sent.id)
    end
  end
end
