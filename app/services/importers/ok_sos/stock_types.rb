module Importers
  module OkSos
    class StockTypes < BaseImporter
      def attributes(data)
        {
          stock_type_id: data['stock_type_id'],
          stock_type_description: data['stock_type_desc']
        }
      end

      def update_by
        [:stock_type_id]
      end
    end
  end
end