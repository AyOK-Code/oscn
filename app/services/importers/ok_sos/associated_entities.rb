module Importers
  module OkSos
    class AssociatedEntities < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          document_number: data['document_number'],
          associated_entity_id: data['associated_entity_id'],
          associated_entity_corp_type_id: data['associated_entity_corp_type_id'],
          primary_capacity_id: data['primary_capacity_id'],
          external_capacity_id: data['capacity_id'],
          associated_entity_name: data['associated_entity_name'],
          entity_filing_number: data['entity_filing_number'],
          entity_filing_date: parse_date(data['entity_filing_date']),
          inactive_date: parse_date(data['inactive_date']),
          jurisdiction_state: data['jurisdiction_state'],
          jurisdiction_country: data['jurisdiction_country'],
          capacity_id: get_cached(::OkSos::Capacity, :capacity_id, data['capacity_id'])&.id,
          entity_id: ::OkSos::Entity.find_by(filing_number: data['filing_number'])&.id,
          corp_type_id: get_cached(::OkSos::CorpType, :corp_type_id, data['associated_entity_corp_type_id'])&.id
        }
      end

      def update_by
        [:associated_entity_id]
      end
    end
  end
end