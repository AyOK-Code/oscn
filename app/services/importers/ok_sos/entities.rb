module Importers
  module OkSos
    class Entities < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          status_id: data['status_id'],
          external_corp_type_id: data['corp_type_id'],
          external_address_id: data['address_id'],
          name: data['name'],
          perpetual_flag: data['perpetual_flag'],
          creation_date: parse_date(data['creation_date']),
          expiration_date: parse_date(data['expiration_date']),
          inactive_date: parse_date(data['inactive_date']),
          formation_date: parse_date(data['formation_date']),
          report_due_date: parse_date(data['report_due_date']),
          tax_id: data['tax_id'],
          fictitious_name: data['fictitious_name'],
          foreign_fein: data['foreign_fein'],
          foreign_state: data['foreign_state'],
          foreign_country: data['foreign_country'],
          foreign_formation_date: parse_date(data['foreign_formation_date']),
          expiration_type: data['expiration_type'],
          last_report_filed_date: parse_date(data['last_report_filed_date']),
          telno: data['telno'],
          otc_suspension_flag: data['otc_suspension_flag'],
          consent_name_flag: data['consent_name_flag'],
          corp_type_id: get_cached(::OkSos::CorpType, :corp_type_id, data['corp_type_id'])&.id,
          entity_address_id: data['address_id'] ? ::OkSos::EntityAddress.find_by(address_id: data['address_id'])&.id : nil
        }
      end

      def unique_by
        [:filing_number]
      end
    end
  end
end
