module Importers
  module OkSos
    class StockData < BaseImporter
      def attributes(data)
        {
          stock_id: data['stock_id'],
          filing_number: data['filing_number'],
          external_stock_type_id: data['stock_type_id'],
          stock_series: data['stock_series'],
          share_volume: data['share_volume'],
          par_value: data['par_value'],
          entity_id: get_cached(::OkSos::Entity, :filing_number, data['filing_number']),
          stock_type_id: get_cached(::OkSos::StockType, :stock_type_id, data['stock_type_id'])
        }
      end

      def import_class
        ::OkSos::StockData
      end

      def unique_by
        [:filing_number, :stock_id]
      end
    end
  end
end
