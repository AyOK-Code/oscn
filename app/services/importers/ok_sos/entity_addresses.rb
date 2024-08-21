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
          zip_string: data['zip_code'],
          zip_extension: data['zip_extension'],
          country: data['county'],
          zip_code_id: get_cached(::ZipCode, :name, data['zip_code'])
        }
      end

      def unique_by
        [:address_id]
      end
    end
  end
end
