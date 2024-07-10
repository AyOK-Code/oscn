module Importers
  module Doc
    class LinkCases
      attr_accessor :counties

      def initialize
        @counties = ::County.all  
      end

      def perform
        counties.each do |county|
          puts "Processing #{county.name} sentences"
          doc_county_id = county.doc_sentencing_county.id
          court_case_mapping = ::CourtCase.mapping(county.id)

          sentences = ::Doc::Sentence.where(doc_sentencing_county_id: doc_county_id)
          puts "Found #{sentences.size} sentences"

          sentences.each do |sentence|
            case_number = sentence.clean_case_number
            county_id = county.id
            court_case_id = court_case_mapping["#{county_id}-#{case_number}"]
            next unless court_case_id

            sentence.update(court_case_id: court_case_id)
          end
        end
      end
    end
  end
end
