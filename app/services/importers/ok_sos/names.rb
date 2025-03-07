module Importers
  module OkSos
    class Names < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          name_id: data['name_id'],
          name: data['name'],
          external_name_status_id: data['name_status_id'],
          external_name_type_id: data['name_type_id'],
          creation_date: parse_date(data['creation_date']),
          inactive_date: parse_date(data['inactive_date']),
          expire_date: parse_date(data['expire_date']),
          all_counties_flag: data['all_counties_flag'],
          consent_filing_number: data['consent_filing_number'],
          search_id: data['search_id'],
          transfer_to: data['transfer_to'],
          received_from: data['received_from'],
          name_type_id: lookup_cached_id(::OkSos::NameType, :name_type_id, data['name_type_id']),
          name_status_id: lookup_cached_id(::OkSos::NameStatus, :name_status_id, data['name_status_id']),
          entity_id: if data['filing_number']
                       lookup_cached_id(::OkSos::Entity, :filing_number,
                                        data['filing_number'])
                     end
        }
      end

      def unique_by
        [:filing_number, :name_id]
      end
    end
  end
end
