module Importers
  module OkSos
    class EntityAddresses < BaseImporter
      def attributes(data)
        {
          address_id: data['address_id'],
          address1: data['address1'],
          address2: data['address2'],
          city: data['city'],
          state: data['state'],
          zip_string: data['zip_string'],
          zip_extension: data['zip_extension'],
          country: data['country'],
          zip_code: get_cached(ZipCode, :name, data['zip_string'])
        }
      end

      def update_by
        [:address_id]
      end
    end
  end
end