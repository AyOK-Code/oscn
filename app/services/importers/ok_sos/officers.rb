module Importers
  module OkSos
    class Officers < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          officer_id: data['officer_id'],
          officer_title: data['officer_title'],
          business_name: data['business_name'],
          last_name: data['last_name'],
          first_name: data['first_name'],
          middle_name: data['middle_name'],
          external_suffix_id: data['suffix_id'],
          external_address_id: data['address_id'],
          creation_date: parse_date(data['creation_date']),
          inactive_date: parse_date(data['inactive_date']),
          last_modified_date: parse_date(data['last_modified_date']),
          normalized_name: data['normalized_name'],
          entity_address_id: get_cached(::OkSos::EntityAddress, :address_id, data['address_id']),
          entity_id: get_cached(::OkSos::Entity, :filing_number, data['filing_number']),
          suffix_id: get_cached(::OkSos::Suffix, :suffix_id, data['agent_suffix_id'])
        }
      end

      def unique_by
        [:filing_number, :officer_id]
      end
    end
  end
end
