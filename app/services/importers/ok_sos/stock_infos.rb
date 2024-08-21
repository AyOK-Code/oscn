module Importers
  module OkSos
    class StockInfos < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          qualify_flag: data['qualify_flag'],
          unlimited_flag: data['unlimited_flag'],
          actual_amount_invested: data['actual_amt_invested'],
          pd_on_credit: data['pd_on_credit'],
          tot_auth_capital: data['tot_auth_capital'],
          entity_id: lookup_cached_id(::OkSos::Entity, :filing_number, data['filing_number'])
        }
      end

      def unique_by
        [:filing_number]
      end
    end
  end
end
