module Importers
  module Doc
    class LinkCounties
      def initialize
        @sentencing_counties = ::Doc::Sentence.distinct.pluck(:sentencing_county).sort
      end

      def perform
        @sentencing_counties.each_with_index do |sentencing_county, index|
          puts "Processing #{sentencing_county} (#{index + 1} of #{@sentencing_counties.size})"
          sentence = ::Doc::Sentence.where(sentencing_county: sentencing_county)
          county = County.find_by('lower(name) = ?', sentencing_county.downcase)
          
          doc_sent = Doc::SentencingCounty.find_or_initialize_by(name: sentencing_county)
          doc_sent.county = county if county.present?
          doc_sent.save
          
          sentence.update_all(doc_sentencing_county_id: doc_sent.id)
        end
      end
    end
  end
end
