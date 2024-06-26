module Importers
  module OkSos
    class Agents < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          external_address_id: data['address_id'],
          business_name: data['business_name'],
          agent_last_name: data['agent_last_name'],
          agent_first_name: data['agent_first_name'],
          agent_middle_name: data['agent_middle_name'],
          agent_suffix_id: data['agent_suffix_id'],
          creation_date: parse_date(data['creation_date']),
          inactive_date: parse_date(data['inactive_date']),
          normalized_name: data['normalized_name'],
          sos_ra_flag: data['sos_ra_flag'],
          entity: ::OkSos::Entity.find_by(filing_number: data['filing_number']),
          entity_address: ::OkSos::EntityAddress.find_by(address_id: data['address_id']),
          suffix: get_cached(::OkSos::Suffix, :suffix_id, data['agent_suffix_id'])
        }
      end

      def update_by
        # todo: check this
        [:filing_number, :agent_suffix_id, :agent_last_name, :agent_last_name]
      end
    end
  end
end