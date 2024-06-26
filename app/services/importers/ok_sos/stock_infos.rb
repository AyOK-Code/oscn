module Importers
  module OkSos
    class StockInfos < BaseImporter
      def attributes(data)
        {
          filing_number: data['filing_number'],
          qualify_flag: data['qualify_flag'],
          unlimited_flag: data['unlimited_flag'],
          actual_amount_invested: data['actual_amount_invested'],
          pd_on_credit: data['pd_on_credit'],
          tot_auth_capital: data['tot_auth_capital'],
          entity: OkSos::Entity.find_by(filing_number: data['filing_number']),
          stock_type: get_cached(OkSos::StockType, :stock_type_id, data['stock_type_id'])
        }
      end

      def update_by
        [] # fix
      end
    end
  end
end