class OkSos::EntityAddress < ApplicationRecord
  belongs_to :zip_code, class_name: 'ZipCode', optional: true
end
