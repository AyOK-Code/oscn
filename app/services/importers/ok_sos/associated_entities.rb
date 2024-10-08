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
          capacity_id: lookup_cached_id(::OkSos::Capacity, :capacity_id, data['capacity_id']),
          entity_id: lookup_cached_id(::OkSos::Entity, :filing_number, data['filing_number']),
          corp_type_id: lookup_cached_id(::OkSos::CorpType, :corp_type_id, data['associated_entity_corp_type_id'])
        }
      end

      def unique_by
        [:filing_number, :associated_entity_id]
      end
    end
  end
end
