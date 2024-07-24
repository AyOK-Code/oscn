module Importers
  module OkSos
    class CorpFilings < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          document_number: data['document_number'],
          external_filing_type_id: data['filing_type_id'],
          external_filing_type: data['filing_type'],
          entry_date: parse_date(data['entry_date']),
          filing_date: parse_date(data['filing_date']),
          effective_date: parse_date(data['effective_date']),
          effective_cond_flag: data['effective_cond_flag'],
          inactive_date: parse_date(data['inactive_date']),
          filing_type_id: get_cached(::OkSos::FilingType, :filing_type_id, data['filing_type_id'])&.id,
          entity_id: ::OkSos::Entity.find_by(filing_number: data['filing_number'])&.id
        }
      end

      def unique_by
        [:filing_number, :document_number]
      end
    end
  end
end
