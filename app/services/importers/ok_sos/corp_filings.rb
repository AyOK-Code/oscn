module Importers
  module OkSos
    class CorpFilings < BaseImprter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          document_number: data['document_number'],
          external_filing_type: data['external_filing_type'],
          entry_date: data['entry_date'],
          filing_date: data['filing_date'],
          effective_date: data['effective_date'],
          effective_cond_flag: data['effective_cond_flag'],
          inactive_date: data['inactive_date'],
          filing_type_id: get_cached(OkSos::FilingType, :filing_type_id, data['filing_type']),
          entity: OkSos::Entity.find_by(filing_number: data['filing_number'])
        }
      end

      def update_by
        [:capacity_id]
      end
    end
  end
end